#coding: utf-8
require 'kconv'
require 'sanitize'
require 'MeCab'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
account = ""
password = ""

Day.delete_all
Day.create(self: "月")
Day.create(self: "火")
Day.create(self: "水")
Day.create(self: "木")
Day.create(self: "金")
Day.create(self: "土")
Day.create(self: "日")

Timetable.delete_all
Timetable.delete_all
for i in 1..7
  Timetable.create(self: i)
end

Term.delete_all
Term.create(season: "春")
Term.create(season: "秋")

client = HTTPClient.new
data = {"u_login" => account, "u_pass" => password}
id = client.post_content("https://vu9.sfc.keio.ac.jp/sfc-sfs/login.cgi", data)
if id =~ /url=(.+?)"/
  id =~ /id=(.+)&type/
  id = $1
end
@subject_detail_urls = []
@syllabus_urls = []
@subjects_name_arr = []
for i in 0..17 do
  url = "https://vu8.sfc.keio.ac.jp/sfc-sfs/sfs_class/student/class_list.cgi?lang=ja&term=2012s&command=search_cat&cat="+i.to_s+"&id="+id
  url = client.get_content(url).toutf8
  url.scan(/<li>(.)(.)(.)(,(.)(.))?：(.*?)\((.*?)<a href="(.*?)" target="_blank">(.*?) <\/a>\((.*?)\)/) do |term, day1, timetable1, str1, day2, timetable2, ks, str2, detail_url, subject, teacher|
    unless Subject.new.exist(subject)
      Subject.create(name: subject)
    end
    unless Teacher.new.exist(teacher)
          Teacher.create(name: teacher)
    end
    term_id = Term.find_by_season(term).id
    day_id = Day.find_by_self(day1).id
    timetable_id = Timetable.find_by_self(Timetable.new.get_timetable_number_from_string(timetable1)).id
    subject_id = Subject.find_by_name(subject).id
    teacher_id = Teacher.find_by_name(teacher).id
    unless SubjectInfo.new.exist(term, day1, timetable1, subject, teacher)
      SubjectInfo.create(term_id: term_id, day_id: day_id, timetable_id: timetable_id, subject_id: subject_id, teacher_id: teacher_id)
    end
    if day2 && timetable2
      day_id = Day.find_by_self(day2).id
      timetable_id = Timetable.find_by_self(Timetable.new.get_timetable_number_from_string(timetable2)).id
      unless SubjectInfo.new.exist(term, day2, timetable2, subject, teacher)
        SubjectInfo.create(term_id: term_id, day_id: day_id, timetable_id: timetable_id, subject_id: subject_id, teacher_id: teacher_id)
      end
    end
    unless @subjects_name_arr.index(subject)
      if /yc=(.*?)&ks=(.*?)$/ =~ detail_url
        yc = $1
        ks = $2
        data = {"cns" => account, "u_pass" => password, "cns_checkmode" => "1", "yc" => yc, "ks" => ks, "lang" => ""}
        syllabus_html = client.post_content("https://vu8.sfc.keio.ac.jp/course2007/summary/syll_view.cgi", data).toutf8
        syllabus_html.scan(/<th nowrap class="ctitle2">(.*?) - (.*?)<br>/) do |ks, subject|
          syllabus_html = syllabus_html.gsub("\n", "")
          syllabus_html.scan(/<th class="sub_title1">科目概要（詳細）<\/th>(.*?)<th class="sub_title1">授業シラバス<\/th>(.*?)<th class="sub_title2">主題と目標／授業の手法など<\/th>(.*?)<th class="sub_title2">教材・参考文献<\/th>/) do |syllabus1, str1, syllabus2|
            syllabus_str = syllabus1 + syllabus2
            syllabus_str = Sanitize.clean(syllabus_str)
            word_arr = []
            mecab = MeCab::Tagger.new
            node = mecab.parseToNode(syllabus_str)
            while node do
              if /名詞/u =~ node.feature.force_encoding("utf-8")
                word_arr << node.surface
              end
              node = node.next
            end
            word_arr.uniq!
            word_arr.each do |word|
              subject_info = SubjectInfo.find_by_term_id_and_day_id_and_timetable_id_and_subject_id_and_teacher_id(term_id, day_id, timetable_id, subject_id, teacher_id)
              unless SyllabusWord.new.exist(word, subject_info)
                SyllabusWord.create(string: word, subject_info_id: subject_info.id)
              end
            end
          end
        end
      end
    end
  end
end
