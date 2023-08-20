# Classification-with-CSP-method

In this project, We want to perform a two-class classification problem using the CSP approach on EEG data.
The first class is related to the idea of ​​foot movement and the second class is related to the idea of ​​performing a series of mental subtraction operations. 

Three 3D matrices and one vector are given in the file "data.mat".

* <p align="justify"> First of all we have to reach spatial filters of CSP method and then filter train data with them. For this purpose, we scroll over each of the experiments and multiply the training data matrix by its output and finally average over the values ​​of the experiments. After obtaining the correlation of each of the classes, in the next step, we apply eig() funtion on these two matrices. In the next step, We arrange the matrix of eigenvalues ​​and form the matrix W_CSP accordingly. As mentioned in the question, two values ​​corresponding to larger and smaller eigenvalues ​​are considered as filters. To apply these two filters on test 49 of two classes, we must multiply the output of these filters in the matrix of this data. Now, if we plot the filtered data, we can see that the output of one of the filters has a lot of dispersion from each class, but the output of the other filter has less dispersion (because according to the course materials, we obtained the matrix W_CSP on the same basis and purpose). The figure below depicts the scatterplot of test 49 data for both classes with both mentioned filters: </p>
![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/b6d95876-6173-4d00-bf79-64379bdb4477)

The numerical values ​​of the variances are as follows:

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/4dac608e-9831-4a9f-b4bb-6ff95d023913)

* The display of the absolute value of the spatial filters of the previous part is as follows:

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/eb2d5904-ba0b-418f-9c1a-9665d1e28e44)

<p align="justify"> As it is clear from the following figure, the values ​​in which the filter has peaked are the channels that had a greater impact after passing through these filters. Channels 20, 17, 12, 8, and 24 are more effective in the first filter and channels 7, 3, 11, and 14 are more effective in the second filter. </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/14ab331a-caca-4797-8873-3b04af5272f0)

* <p align="justify"> We calculate the variance of filtered data considering 14 more important spatial filters. In the W_CSP matrix that we obtained earlier, we extract columns 1 to 7 and 24 to 30 and form the desired filter. First, to filter the data for each of the experiments, we get the product of the filter matrix's transformation in the data of both classes. Now, in order to obtain the variance of the data in the same loop that we wrote for scrolling over the experiments, we obtain the variance for each experiment with the var command. In fact, the variance of the calculated data gives us the same vector of features. </p>

<p align="justify"> Now, to implement and use the LDA classifier, we must first find the average matrix and the variance matrix of two classes of data. According to the relationship we have: </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/d52332da-f305-4453-9f80-f5a65b3fe6ac)

<p align="justify"> In order to implement the above relationships, it should be noted that the x's here are the variance of the data or the vector of features. To calculate the average, we calculate the sum of these vectors over all trials and divide by the number of trials. In the next step, we form the average matrix according to the following relationship: </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/d89de367-0833-412c-8929-1a769d10521e)

Now we need to get the covariance matrix of the data, which we need to implement according to the following relationship:

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/2513a346-2ee1-4145-bfe9-8fd4ed7cc2a5)

<p align="justify"> Similar to what we implemented for averages, we will have the same algorithm for this section, with the difference that according to the above relationship, the average of each class of data is subtracted from the data of the same class, and then the averaging is done on the products. Finally, we have the covariance matrix of the data as follows </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/12b907b2-d928-41c4-aad2-df1d91c78852)

<p align="justify"> In the next step, in order to obtain the matrix that is needed to find W_LDA, we apply the eig() transformation on the two obtained matrices (the mean matrix and the covariance matrix). Similar to what we did in the first part, through the matrix of eigenvalues ​​and sorting it, the column corresponding to the largest eigenvalue can be extracted and called the best linear transformation or W_LDA. In fact, we apply the transformation eig() because we want to maximize the function f defined as follows: </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/8b3dfed1-e0a2-4b52-afca-ee00bc2336aa)

After normalizing the linear transformation, we use the following relation to obtain the corresponding border:

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/46864d0a-a946-4fc5-8201-c551777d322d)

The values ​​of the vector W_LDA and c obtained using the above relations and implementation in the MATLAB environment are as follows:

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/c436eee9-5551-4a99-af19-3c6ff5e07515)

* <p align="justify"> First, we filter the test data using 14 more important spatial filters, that is, we multiply the transform matrix of the filter by the test data, which we do separately for each of the 40 tests, and filter the data and save them in a three-dimensional matrix. In the next step, we obtain the variance of the filtered data in the same way as we implemented in the third part, that is, we obtain the variance of each of the experiments in the same loop that we formed to navigate over the experiments. Now we have to depict these features (the same variance of the data) on the line W_LDA, for this similar task as before, it is necessary to multiply the transform W_LDA in the data feature matrix. Now, in order to give a label to the data of each experiment, we must measure the imaged data for each experiment with c value. If you pay close attention, according to the output of the average data shown in the figure below, the average data of the first class is greater than the value of c and the average of the data of the second class is less than c, so by comparing the data depicted on the line W_LDA and the value of c, you can understand What is the appropriate label for that series of data. </p>

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/fbee5684-c77d-4562-9710-25bd7967d138)

<p align="justify"> The method we implemented in MATLAB is that we have placed the condition that the data is larger than c, which works in MATLAB in such a way that if the condition is met, it returns a logical value of 1, and if it is not met, it returns 0. As a result, for the case where we have output 1, it means that the data is larger than c, so it is placed in class 1, and otherwise, it is labeled as 2, which is related to the second class of data. In this way, we form the label matrix. </p>

* <p align="justify"> We compare the vector of the estimated labels and the real labels of the data, and it can be seen that we estimated the data labels incorrectly in 6 cases. </p>
As requested, we have drawn the estimated labels and actual data labels as follows based on the test data number.

![image](https://github.com/SogolGoodarzi/Classification-with-CSP-method/assets/125180530/b24b35ed-7420-4ecf-95a3-0a92828ae2b2)

As we said earlier, our estimation was wrong for 6 of the data, which can be seen in the above figure.
