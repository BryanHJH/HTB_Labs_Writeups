-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: Certificate_WEBAPP_DB
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `course_sessions`
--

DROP TABLE IF EXISTS `course_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `course_id` int(11) NOT NULL,
  `type` enum('session','quizz') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_sessions`
--

LOCK TABLES `course_sessions` WRITE;
/*!40000 ALTER TABLE `course_sessions` DISABLE KEYS */;
INSERT INTO `course_sessions` VALUES (1,'Session-1',1,'session'),(2,'Session-2',1,'session'),(3,'Session-3',1,'session'),(4,'Session-4',1,'session'),(5,'Quizz-1',1,'quizz'),(6,'Session-5',1,'session'),(7,'Session-6',1,'session'),(8,'Quizz-2',1,'quizz'),(9,'Session-7',1,'session'),(10,'Session-8',1,'session'),(11,'Session-9',1,'session'),(12,'Session-10',1,'session'),(13,'Quizz-3',1,'quizz'),(14,'Introduction',2,'session'),(17,'Session-1',2,'session'),(18,'Session-2',2,'session'),(19,'Quizz-1',2,'quizz'),(20,'Session-3',2,'session'),(21,'Session-4',2,'session'),(22,'Session-5',2,'session'),(23,'Quizz-2',2,'quizz'),(24,'Session-6',2,'session'),(25,'Session-7',2,'session'),(26,'Final',2,'quizz'),(27,'Session-1',3,'session'),(28,'Session-2',3,'session'),(29,'Session-3',3,'session'),(30,'Session-4',3,'session'),(31,'Session-5',3,'session'),(32,'Session-6',3,'session'),(33,'Session-7',3,'session'),(34,'Session-8',3,'session'),(35,'Session-9',3,'session'),(36,'Final',3,'quizz'),(37,'Intro',4,'session'),(38,'Session-1',4,'session'),(39,'Session-2',4,'session'),(40,'Session-3',4,'session'),(41,'Session-4',4,'session'),(42,'Quizz-1',4,'quizz'),(43,'Session-5',4,'session'),(44,'Quizz-2',4,'quizz'),(45,'Session-6',4,'session'),(46,'Session-7',4,'session'),(47,'Session-8',4,'session'),(48,'Quizz-3',4,'quizz');
/*!40000 ALTER TABLE `course_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `objectives` text NOT NULL,
  `eligibility` text NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `fee` int(11) NOT NULL,
  `time_required` int(11) NOT NULL,
  `banner` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'How to be the employee of the month!',' <p>        The course \"How to Be the Employee of the Month!\" is designed to empower individuals with the skills, attitudes,         and behaviors required to excel in their professional roles. Through this program, participants will learn how to         stand out in their workplace by consistently delivering high-quality results, demonstrating a proactive approach,         and fostering strong interpersonal relationships. Key objectives include:    </p>    <ul>        <li><strong>Cultivating a Growth Mindset:</strong> Understand the importance of a positive attitude, adaptability, and resilience in achieving professional excellence.</li>        <li><strong>Effective Communication:</strong> Master the art of clear, concise, and professional communication, including verbal, written, and non-verbal skills.</li>        <li><strong>Time and Priority Management:</strong> Learn techniques to manage tasks effectively, meet deadlines, and balance workloads without compromising quality.</li>        <li><strong>Teamwork and Collaboration:</strong> Enhance your ability to work cohesively with colleagues, contribute to team success, and build strong relationships.</li>        <li><strong>Problem-Solving and Innovation:</strong> Develop critical thinking and creativity to address challenges and bring innovative solutions to your workplace.</li>        <li><strong>Leadership and Initiative:</strong> Explore how to take ownership of tasks, show initiative, and exhibit leadership qualities even in non-leadership roles.</li>        <li><strong>Recognition and Impact:</strong> Gain insights into how your contributions can align with organizational goals, helping you achieve recognition as an exemplary employee.</li>    </ul>    <p>        By the end of this course, participants will have a clear understanding of how to deliver value consistently, maintain a professional demeanor,         and position themselves as indispensable assets to their teams and organizations.</p>','<p>        This course is suitable for individuals at various stages of their professional journey. While no formal qualifications are required,         participants will benefit most if they possess basic workplace experience. This could include familiarity with common office tasks,         such as collaborating with team members, meeting deadlines, and handling responsibilities within a professional environment.         A general understanding of organizational structure and functions is also advantageous, as the course builds upon practical scenarios         and real-world examples.    </p>    <p>        Additionally, individuals who have faced workplace challenges-such as managing conflicts, improving productivity, or striving to exceed expectations-will find this course particularly relevant.         Enthusiasm to learn, a willingness to reflect on personal behaviors, and a commitment to professional growth are key attributes for those enrolling.         Whether you are a new hire eager to make a lasting impression or an experienced professional looking to refine your skills, this course provides the tools to help you shine in any workplace setting.    </p>',1,150,14,'p1.jpg'),(2,'Learn Angular JS Course for Legendary Persons','<p>        The \"Learn AngularJS\" course is designed to equip participants with the foundational knowledge and advanced skills         needed to develop dynamic and efficient web applications using AngularJS. This course takes a hands-on approach,         providing a thorough understanding of AngularJS core features, its MVC architecture, and its ability to build robust         and scalable single-page applications (SPAs). Key objectives include:    </p>    <ul>        <li><strong>Understanding AngularJS Framework:</strong> Learn the fundamentals of AngularJS, its architecture, and why it is a popular choice for web development.</li>        <li><strong>Data Binding and Dependency Injection:</strong> Master two-way data binding and dependency injection to create seamless interactions between the view and model layers.</li>        <li><strong>Directives and Filters:</strong> Understand how to create custom directives and utilize built-in filters to extend HTML functionality and manipulate data effectively.</li>        <li><strong>Routing and Navigation:</strong> Learn how to implement routing in AngularJS to build SPAs with smooth navigation and efficient content loading.</li>        <li><strong>Form Handling and Validation:</strong> Explore AngularJS capabilities for building forms, implementing validation, and ensuring a user-friendly experience.</li>        <li><strong>Integrating with Backends:</strong> Learn how to integrate AngularJS applications with RESTful APIs for data exchange and dynamic updates.</li>        <li><strong>Testing and Debugging:</strong> Develop best practices for testing AngularJS components and debugging to ensure application reliability.</li>    </ul>    <p>        By the end of this course, participants will be proficient in developing responsive and interactive web applications using AngularJS,         preparing them for real-world projects and professional growth in the field of web development.    </p>','<p>        This course is intended for individuals who are familiar with basic web development concepts and have a working knowledge of HTML, CSS, and JavaScript.         Prior experience with JavaScript frameworks or libraries, such as jQuery, is beneficial but not mandatory. A basic understanding of how web applications         work, including client-server interactions and API usage, will help participants better grasp AngularJS capabilities.     </p>    <p>        Enthusiasm to learn new technologies, problem-solving skills, and a commitment to building hands-on projects are key attributes for success in this course.         Whether you are a developer looking to expand your skill set or someone new to frameworks and eager to start a career in front-end development,         this course will provide the knowledge and tools needed to master AngularJS.    </p>',8,99,9,'p2.jpg'),(3,'How to be the next Leonardo Da Vinci!','<p>        The \"How to Be the Next Leonardo Da Vinci!\" course is designed to unlock your creative potential and inspire you         to think and create like one of historys greatest polymaths. Leonardo Da Vinci genius spanned art, science, engineering, and innovation,         and this course aims to guide participants in embracing a multidisciplinary approach to creativity. Key objectives include:    </p>    <ul>        <li><strong>Developing a Polymath Mindset:</strong> Learn to explore multiple disciplines and integrate diverse fields of knowledge to spark innovation and creativity.</li>        <li><strong>Mastering the Art of Observation:</strong> Enhance your ability to notice details and patterns in everyday life, mirroring Da Vinci keen eye for the world around him.</li>        <li><strong>Fostering Curiosity and Inquiry:</strong> Cultivate an insatiable curiosity to ask questions, seek answers, and approach problems with a fresh perspective.</li>        <li><strong>Embracing Artistic Techniques:</strong> Study the fundamentals of drawing, painting, and sketching inspired by Da Vinci artistic practices.</li>        <li><strong>Applying Scientific Principles:</strong> Understand the interplay between science and art, experimenting with techniques like anatomical drawing and mechanical design.</li>        <li><strong>Innovative Thinking:</strong> Learn how to think outside the box and develop unique solutions to complex problems, inspired by Da Vinci inventions and designs.</li>        <li><strong>Personal Development:</strong> Reflect on your creative process, build discipline, and adopt habits that foster continuous growth and mastery.</li>    </ul>    <p>        By the end of this course, participants will have a deeper appreciation of the Renaissance spirit and practical tools to apply Da Vinci principles         to their personal and professional lives, regardless of their field or discipline.    </p>','<p>        This course welcomes anyone with a passion for creativity and a willingness to explore new ideas. No specialized knowledge is required,         making it suitable for beginners and experienced individuals alike. However, a basic understanding of artistic or scientific concepts,         such as drawing, problem-solving, or curiosity about innovation, can enhance your experience in the course.    </p>    <p>        Participants who have prior exposure to creative endeavors-whether through art, science, writing, or design-may find themselves building upon their existing skills.         The most important prerequisites are an open mind, a commitment to learning, and a desire to explore the intersection of creativity and knowledge,         much like Da Vinci himself. This course is perfect for anyone seeking inspiration to break boundaries and leave a lasting impact in their chosen field.    </p>',6,88,12,'p3.jpg'),(4,'The advanced programming alogorithms','<p>        \"The Advanced Programming Algorithms\" course is tailored for experienced developers and computer scientists who aim         to deepen their understanding of advanced algorithmic concepts and techniques. This course emphasizes problem-solving,         computational efficiency, and the ability to implement sophisticated algorithms in real-world scenarios. Key objectives include:    </p>    <ul>        <li><strong>Understanding Advanced Data Structures:</strong> Learn about advanced data structures such as segment trees, Fenwick trees, and graph structures to optimize algorithm performance.</li>        <li><strong>Mastering Graph Algorithms:</strong> Explore algorithms like Dijkstras, Floyd-Warshall, Bellman-Ford, and network flow algorithms to solve complex graph-related problems.</li>        <li><strong>Dynamic Programming Techniques:</strong> Develop advanced skills in solving optimization problems using dynamic programming, including memoization and state-space reduction.</li>        <li><strong>Divide and Conquer Strategies:</strong> Understand and implement divide-and-conquer approaches for algorithmic efficiency, such as fast Fourier transform (FFT) and binary search in higher dimensions.</li>        <li><strong>String Processing Algorithms:</strong> Learn string matching and manipulation techniques, including the KMP algorithm, Z-algorithm, and suffix arrays.</li>        <li><strong>Exploring Computational Geometry:</strong> Dive into algorithms for geometric problems, such as convex hull, line intersection, and Voronoi diagrams.</li>        <li><strong>Problem-Solving Skills:</strong> Engage in competitive programming challenges to develop analytical thinking and apply learned techniques effectively.</li>    </ul>    <p>        By the end of this course, participants will have a comprehensive understanding of advanced algorithmic techniques,         enabling them to tackle complex programming challenges, improve code efficiency, and excel in competitive programming or real-world software development tasks.    </p>','<p>        This course is designed for individuals with a strong foundation in programming and basic algorithms. Participants should         have experience in at least one programming language, such as Python, Java, or C++, and a solid understanding of fundamental data         structures like arrays, linked lists, stacks, and queues. Familiarity with sorting algorithms, recursion, and basic graph theory is also essential.    </p>    <p>        Individuals who have prior experience with competitive programming or have worked on algorithmic challenges will find this course particularly enriching.         Enthusiasm for problem-solving, analytical thinking, and a willingness to tackle complex problems are key to success in this course. Whether you are a software developer aiming         to optimize applications or a student preparing for technical interviews, this course provides the advanced knowledge and skills needed to excel.    </p>',7,112,22,'p4.jpg');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `role` enum('student','teacher','admin') DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Lorra','Armessa','Lorra.AAA','lorra.aaa@certificate.htb','$2y$04$bZs2FUjVRiFswY84CUR8ve02ymuiy0QD23XOKFuT6IM2sBbgQvEFG','2024-12-23 20:43:10','teacher',1),(6,'Sara','Laracrof','Sara1200','sara1200@gmail.com','$2y$04$pgTOAkSnYMQoILmL6MRXLOOfFlZUPR4lAD2kvWZj.i/dyvXNSqCkK','2024-12-23 20:47:11','teacher',1),(7,'John','Wood','Johney','johny009@mail.com','$2y$04$VaUEcSd6p5NnpgwnHyh8zey13zo/hL7jfQd9U.PGyEW3yqBf.IxRq','2024-12-23 21:18:18','student',1),(8,'Havok','Watterson','havokww','havokww@hotmail.com','$2y$04$XSXoFSfcMoS5Zp8ojTeUSOj6ENEun6oWM93mvRQgvaBufba5I5nti','2024-12-24 17:08:04','teacher',1),(9,'Steven','Roman','stev','steven@yahoo.com','$2y$04$6FHP.7xTHRGYRI9kRIo7deUHz0LX.vx2ixwv0cOW6TDtRGgOhRFX2','2024-12-24 20:05:05','student',1),(10,'Sara','Brawn','sara.b','sara.b@certificate.htb','$2y$04$CgDe/Thzw/Em/M4SkmXNbu0YdFo6uUs3nB.pzQPV.g8UdXikZNdH6','2024-12-26 05:31:26','admin',1),(12,'test','test','test','test@test.com','$2y$04$L0IFWA4vAj6L3w1YpdJemeOQmumRkoWKooGk.TB7CJx5uVMBjfRAK','2025-06-02 14:26:48','student',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_courses`
--

DROP TABLE IF EXISTS `users_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_courses`
--

LOCK TABLES `users_courses` WRITE;
/*!40000 ALTER TABLE `users_courses` DISABLE KEYS */;
INSERT INTO `users_courses` VALUES (1,9,2),(2,11,2),(3,11,4),(4,12,3);
/*!40000 ALTER TABLE `users_courses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-02  8:28:41
