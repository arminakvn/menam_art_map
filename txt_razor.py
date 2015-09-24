__author__ = 'BharatRaju'
from textrazor import TextRazor
import os,sys
reload(sys)
sys.setdefaultencoding("utf-8")
import re
from nltk_contrib.timex import *
from bs4 import BeautifulSoup
import nltk
from operator import itemgetter
import csv
import glob



#collecting all stop words
stoplist_file = open("stoplist.txt",'rb')
stop_words=set([])
for each_line in stoplist_file:
    each_line=each_line.replace('\n','')
    each_line.strip()
    stop_words.add(each_line)

#File to extract from and few modifications in text to extract content better
path = r'C:\Users\BharatRaju\Desktop\RA_IR\artnet.com\current folder'
for filename in glob.glob(os.path.join(path, '*.txt')):
    f=open(filename,"rb")
    i=1
    content=''
    for each_line in f:
        if i==1:
            each_line=each_line.replace('\n','')
            artist_name = each_line
        if i>2:
            #print(each_line)
            #each_line=each_line.replace('\n',' ')
            #print(each_line)
            each_line=each_line.replace('-',' ')
            each_line=each_line.replace(').',' .')
            each_line=each_line.replace('(',' ')
            each_line=each_line.replace(')',' ')
            each_line=each_line.replace('.',' .')
            #each_line=each_line.strip()
            #each_line=each_line.replace('  ',' ')
            each_line=re.sub(r'[A-Z][.]', '', each_line)
            #print(each_line)
            content+=each_line
        i+=1

    #calling the textrazor api
    client = TextRazor(api_key="2b14ce2ddeda92c1f4a4f10b8471d4c5c030cb594be4cbe7303f7366", extractors=["entities", "topics","relations","words","noun_phrases"])

    #Getting a list of sentences seperated based on '.'
    list_of_sentences_content = content.split('.')
    seperated = []
    for each_sentence in list_of_sentences_content:
        s=each_sentence.split('.')
        #s=each_sentence
        #seperated.append(s)
        seperated+=s
    Temporal_list_of_events=[]
    sentences=[]
    for s in seperated:
        #finding time in each sentence
        time_tagged = tag(s)
        time=re.findall('<TIMEX2>(.*?)</TIMEX2>', str(time_tagged))

        #looking for location and organization entities using textrazor in each sentence else excluding them
        try:
            response = client.analyze(s)
            relation = response.relations()
            entities= response.entities()
        except Exception,e:
            print str(e)
            continue
        #looking for location in a sentence
        for entity in entities:

            for each_item in entity.freebase_types:
                if 'location' in each_sentence or 'organization' in each_item or 'place' in each_sentence:
                    sentences+=[s]
                    break;


        for each_w in relation:
            #print(each_w)
            predicate_words=each_w.predicate_words
            list_of_predicates_temp=[]
            for each_predicate in predicate_words:
                each_predicate = re.sub("\d+", "", str(each_predicate))
                each_predicate=str(each_predicate).replace("TextRazor Word:",'')
                each_predicate=str(each_predicate).replace("at position",'')
                each_predicate=each_predicate.replace("\n",'')
                each_predicate=each_predicate.replace("'",'')
                each_predicate=each_predicate.strip()
                each_predicate=each_predicate.split(' ')

                list_of_predicates_temp.append(each_predicate[0])
            #print list_of_predicates
            list_of_predicates=[]
            for each_predicate in list_of_predicates_temp:
                if each_predicate not in stop_words:
                    list_of_predicates.append(each_predicate)
            predicate_relations = each_w.params
            object=str(predicate_relations[1]).replace("TextRazor RelationParam:\"OBJECT\" at positions ",'')
            object=object.replace("TextRazor Word:",'')
            object=object.replace("at position",'')
            object=object.replace("[",'')
            object=object.replace("]",'')
            object=object.replace("\"",'')
            object = re.sub("  \d+", "", object)
            object=object.replace("at position",'')
            object=object.strip()
            obj_list = object.split(',')

            object_list=[]
            for each_obj in obj_list:
                each_obj=each_obj.strip()
                if each_obj not in stop_words:
                    object_list.append(each_obj)
            obj_num=0
            time_no=1
            for each_obj in object_list:
                if each_obj=='':
                    object_list[obj_num]="Time: " +str(time_no)
                    time_no+=1
                obj_num+=1
            #list_of_params=str(predicate_relations).split(',')
            #print(type(list_of_predicates),type(object_list))
            location=set([])
            organization=set([])
            if time==None:
                #print "Afro","predicates:",list_of_predicates,"objects:",object_list

                for entity in entities:
                    for each_item in entity.freebase_types:
                        if 'location' in each_item:
                            location.add(entity.matched_text)
                        if 'organization' in each_item:
                            organization.add(entity.matched_text)
                Temporal_list_of_events.append([artist_name,"predicates:",list_of_predicates,"objects:",object_list,"Location: ",location, "Organization",organization])
            else:
                #print "Afro","predicates:",list_of_predicates,"objects:",object_list,"Time: ",time#,time_of_event
                for entity in entities:
                    for each_item in entity.freebase_types:
                        if 'location' in each_item:
                            location.add(entity.matched_text)
                        if 'organization' in each_item:
                            organization.add(entity.matched_text)
                Temporal_list_of_events.append([artist_name,"predicates:",list_of_predicates,"objects:",object_list,"Time: ",time,"Location: ",location,"Organization",organization])
            time=None
            prev_predicates=list_of_predicates


            break



    # Temporal_list_of_events

    enumerated_Temporal_list_of_events = list(enumerate(Temporal_list_of_events))
    #print enumerated_Temporal_list_of_events
    number_of_pos = len(enumerated_Temporal_list_of_events)
    time_enumerated_Temporal_list_of_events=[]

    for each_item in enumerated_Temporal_list_of_events:
        if each_item[1][6]:
            time_enumerated_Temporal_list_of_events.append(each_item)
    #print  time_enumerated_Temporal_list_of_events
    sorted_time_enumerated_Temporal_list_of_events=sorted(time_enumerated_Temporal_list_of_events,key=lambda x:x[1][6])
    #sorted(time_enumerated_Temporal_list_of_events,key=int(itemgetter(1)(6)))
    #print sorted_time_enumerated_Temporal_list_of_events
    new_sorted_time_enumerated_Temporal_list_of_events=[]
    new_pos=[]
    for each_item in sorted_time_enumerated_Temporal_list_of_events:
        new_sorted_time_enumerated_Temporal_list_of_events.append(each_item[1])
        new_pos.append(each_item[0])
    #print new_sorted_time_enumerated_Temporal_list_of_events
    #print(new_pos)

    new_enumerated_Temporal_list_of_events= list(enumerate(new_sorted_time_enumerated_Temporal_list_of_events))
    j=0
    k=0
    sorted_temporals=[]
    for i in range(number_of_pos):
        if i in new_pos:
            k=new_pos[j]
            j+=1
            sorted_temporals.append(enumerated_Temporal_list_of_events[k])
        else:
            sorted_temporals.append(enumerated_Temporal_list_of_events[i])

    #Writing sorted events based on time into comma seperated file with artist name, place, organization and time
    f = open("artists.csv", 'a')
    for e_i in sorted_temporals:
        split = e_i[1]
        #print(split[0], split[6], split[8], split[10])
        print(split)
        writer = csv.writer(f,quoting=csv.QUOTE_ALL)
        #sp = str(split[0]) + ',' + str(split[8]) + ',' + str(split[10]) + ',' + str(split[6])
        sp =[split[0], list(split[8]), list(split[10]), list(split[6]),split[2],split[4]]
        writer.writerow(sp)

