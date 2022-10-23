create table scraping_mail(
    id bigint auto_increment primary key,
    mail_title varchar(256),
    contents varchar(1024),
    received_date int,
    classify varchar(32),
    email_service_id int,
    index scraping_mail_email_service_id(email_service_id),
    index mail_title(mail_title),
    index received_date(received_date),
    index classify(classify)
);

create table email_service (
    id int auto_increment primary key,
    name varchar(64),
    index email_service_name(name)
);

insert into email_service (id, name)
values (1, 'naver'),
        (2, 'nate');
