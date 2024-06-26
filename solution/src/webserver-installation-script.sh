#!/bin/bash

# Dependency installation.
sudo yum update -y
sudo yum install httpd

# systemctl controls.
sudo systemctl start httpd
sudo systemctl enable httpd

# Web Page Population.
sudo echo '<!DOCTYPE html><html lang="en"><head>    <meta charset="UTF-8">    <meta name="viewport" content="width=device-width, initial-scale=1.0">    <title>ACS-Final Project Web Page</title></head><style>    .container{        display: flex;    }    .container-child{        height: 25vh;    }</style><body>    <h1> ACS Final Project Webpage</h1>    <h2> Group Members:</h2>    <ul>        <li>Dirghayu Joshi</li>        <li>Rujal Maharjan</li>        <li>Malika</li>        <li>Parinaya</li><li>Mahesh</li>    </ul>    <h2>Images from the S3 bucket:</h2>    <div class="container">        <img class="container-child" src="https://thechive.com/wp-content/uploads/2019/12/person-hilariously-photoshops-animals-onto-random-things-xx-photos-25.jpg?attachment_cache_bust=3136487&quality=85&strip=info&w=400" alt="Image 1">        <img class="container-child" src="https://9b16f79ca967fd0708d1-2713572fef44aa49ec323e813b06d2d9.ssl.cf2.rackcdn.com/1140x_a10-7_cTC/web-illustration-anonymous-person-paid-1500px-1707848019.jpg" alt="Image 2">        <img class="container-child" src="https://sm.ign.com/ign_nordic/review/l/lost-in-ra/lost-in-random-review_9hhv.jpg" alt="Image 3">    </div></body></html>' > /var/www/html/index.html