

## Inspiration 💡

The world of art has undergone a significant transformation in recent months with the advent of GANs and other deep learning technologies. Models such as DALL-E, mid-journey, and Stable Diffusion have revolutionized the way we think about creating our interaction with art. They have shown us that machines can be trained to generate images that are not only stunningly beautiful but also unique and unpredictable.

While these models easily manipulate bits to create art, they are far from affecting artistic forms in the physical world such as painting, sculpting, and pottery. Our team is fascinated by one such lesser-known artform known as light painting.

Light painting is a way of creating pictures using a camera and a light source, such as a flashlight, glow stick, or LED light. It's like drawing in the air with light!

To create a light painting, you set your camera to a long exposure, which means that the camera's shutter stays open for a few seconds or even minutes. During this time, you can use your light source to "draw" or "paint" in the air, and the camera will capture the light trails you create. The best part about light painting is that you can be really creative and make all kinds of cool pictures. You can write your name, draw shapes, or even make it look like you're holding a ball of light! The possibilities are endless.

![multicamera_painting_with_light](https://i0.wp.com/breezesys.com/Images/multicamera_painting_with_light.GIF?resize=474%2C418)

Having attempted creating several light paintings ourselves, we have realized a crucial painpoint: you have to get the light painting right in the first attempt. It is rare for hobby-artists to have the ability to get the painting right the first time and even professional artists are dissuaded from further pursuing this  *interactive* art medium. 

Motivated to build an artistic solution for the physical world, our team decided to make use of the technology we're most excited about: robotics.

The inspiration behind this project is to explore the intersection between physical art and manipulator robot arms. By combining the precision and accuracy of robot arms with the creativity and imagination of artists, we hope to push the boundaries of what light paintings can be created. 

We call our Light painting robot, Mechangelo!

[![Group-1686550969.png](https://i.postimg.cc/ThMBSD7q/Group-1686550969.png)](https://postimg.cc/GTKMTH1H)

## What it does 🤔

Mechangelo is a service that allows users to transform their sketches to light paintings. It is a system comprised of 3 components: a robotic arm, a long exposure camera, and an iOS drawing application.


Here's the user workflow: an artist or a light-painting-enthusiast can draw a 2D sketch on a canvas while having several tools to edit and color the image as they please. After making all their edits, they order the image to be light-painted. Now, the robot manipulator arm (uArm) is put to work. The robot receives the image and converts the jpeg to GCode (the instructions used to move the extruder in a 3D printer) using contours extraction as well as some computer vision techniques. This light painting is captured by our light exposure camera and sent back to our user's iPad app.

Essentially, it allows light painters to pre-edit the light painting and introduces light painting to enthusiasts in an **interactive manner.**

[![tri-comp.png](https://i.postimg.cc/L8tMd21B/tri-comp.png)](https://postimg.cc/rDwHx6gK)


##  Best Interactivity Hack -- Track Prize🎨


Our team's Light painting robot, Mechangelo, combines physical art with robotic manipulation and computer vision techniques to provide a new level of interactivity in light painting. We believe our project stands out in the Best Interactivity Hack track because it allows users to pre-edit their light paintings using an iOS drawing application, providing them with creative control and an immersive experience. Our robot arm takes the user's drawing and creates a physical light painting, which is captured by a camera and sent back to the user's device, completing the feedback loop. Mechangelo bridges the gap between traditional art and technology, allowing users to explore a new form of art that is interactive and engaging.

Furthermore, our project has the potential to inspire more people to try light painting as an art medium, as it reduces the barrier to entry by simplifying the process and providing a user-friendly interface. Mechangelo could revolutionize the way artists interact with light painting and inspire the creation of more interactive and innovative art projects. Therefore, we believe that our Light painting robot, Mechangelo, deserves the Best Interactivity Hack track prize and would appreciate the opportunity to continue exploring the intersection between physical art and technology.

[![Tech-Stack.png](https://i.postimg.cc/Y2Q15PSf/Tech-Stack.png)](https://postimg.cc/MXKMRdVv)

## Most Creative Use of GitHub 👩🏻‍💻

We used github to collaborate and create this project in multiple ways:

*  **Collaboration with Pull Requests and Issues:** We were a team of four members. Therefore, we created detailed **Pull Requests** to collaborate over this project. Moreover, all the bugs/features were dealt using **Issues**. We also requested **Reviews** on the PRs so that the changes could not break the product.

*  **Collaboration with Project:** Recently, we came accross Github Projects. For this hack, we utilized Github Projects to keep a track of each one's progress. We created different sections: ToDo, In Progress, Under Review, Finished and Video for the perfect team collaboration. You can check our Project ([Mechangelo (github.com)](https://github.com/users/Gaurang-1402/projects/1)).

*  **Branch Usage:** Since we had 3 components, robot arm code, iOS App, as well as the long exposure camera, we initially thought of creating multiple repostories. But smartly using branches, helped us store our code without using two repos. The extension is stored on the ```main``` branch and the features are on various branches. After using the branches, it was quite easy for us to create PRs.


*  **Github Wiki:** We also utilized the Github Wiki to explain how to setup the project locally. You can check the wiki [Home · Gaurang-1402/Mechangelo Wiki (github.com)](https://github.com/Gaurang-1402/Mechangelo/wiki)

* **Github Workflows:** As a bonus, we also utilized Github workflows to assign labels to the PR to make the repository more readable.

*  **Github Templates:** The Pull Requests and Issues already have a template. Just try to raise an issue, you will be prompted to choose between two options: Feature/Bug. The templates are created using yaml file. Apart from that, we have also added MIT License and the ReadMe file.

[![gh-finish.png](https://i.postimg.cc/MTCwBDfq/gh-finish.png)](https://postimg.cc/XGktS9gz)
***


## How we built it ⚙️

The whole process can be broken into the following points :-
- SwiftUI on the frontend
-  Python, OpenCV, and Robot interface libraries on the backend
- Services like Firebase and GitHub
- Robot- uArm Python SDK


[![built-it.png](https://i.postimg.cc/j23ydpnM/built-it.png)](https://postimg.cc/xNHX6FRm)


## Design 🎨

We were heavily inspired by the revised version of **Double Diamond** design process, which not only includes visual design, but a full-fledged research cycle in which you must discover and define your problem before tackling your solution & then finally deploy it.

![DD](https://i.postimg.cc/W4bvXqDj/image-148.png)

> 1. **Discover**: a deep dive into the problem we are trying to solve.
> 2. **Define**: synthesizing the information from the discovery phase into a problem definition.
> 3. **Develop**: think up solutions to the problem.
> 4. **Deliver**: pick the best solution and build that.

Moreover, we utilized design tools like Figma,  Photoshop & Illustrator to prototype our designs before doing any coding. Through this, we are able to get iterative feedback so that we spend less time re-writing code.

![breaker.png](https://i.postimg.cc/YSvrrWnc/breaker.png)

# Research 📚
Research is the key to empathizing with users: we found our specific user group early and that paves the way for our whole project. Here are a few of the resources that were helpful to us —


- [Long Exposure with Python and OpenCV | by Kelvin Salton do Prado | Medium](https://kelvinsp.medium.com/long-exposure-with-python-and-opencv-a242e1f1e42f)
- Swift
- PencilKit
- PhotoKit
- FirebaseStorage
- [uArm-Developer/uArm-Python-SDK: New python library for Swift, Swift Pro (github.com)](https://github.com/uArm-Developer/uArm-Python-SDK)
- [What is Light Painting? (How to Draw with Light + What You Need) (shotkit.com)](https://shotkit.com/light-painting/)

**CREDITS**
- **Design Resources** : Freepik, Behance
- **Icons** : Icons8, fontawesome
- **Font** : Urbanist / Roboto / Raleway 


[![mechanegelo.png](https://i.postimg.cc/rppNqHxK/mechanegelo.png)](https://postimg.cc/zy9gj0dr)


## What we learned 🙌
**Proper sleep is very important! :p** Well, a lot of things, both summed up in technical & non-technical sides. Also not to mention, we enhanced our googling and Stackoverflow searching skills during the hackathon :)

