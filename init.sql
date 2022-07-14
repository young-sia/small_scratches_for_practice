create table scraping_mail_naver(
    id bigint auto_increment primary key,
    mail_title varchar(256),
    contents varchar(1024),
    received_date int,
    classify varchar(32)
    index mail_title(mail_title)
    index received_date(received_date)
    index classify(classify)
);

create table scraping_mail_nate(
    id bigint auto_increment primary key,
    mail_title varchar(256),
    contents varchar(1024),
    received_date int,
    classify varchar(32)
    index mail_title(mail_title)
    index received_date(received_date)
    index classify(classify)
);