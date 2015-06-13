# DataRobot

This project aims for the internship at DataRobot.

1.	Dataset: Online News Popularity from UCI, 2015 (http://archive.ics.uci.edu/ml/datasets/Online+News+Popularity)
2.	Number of Instances: 39644 (at the time I downloaded)
3.	Number of Attributes: 61 (including target variable)
4.	Missing Attribute Values: None
5.	Task: Regression-Building predictive models for predicting the number of shares (attribute: shares) for a particular article     published by Mashable (www.mashable.com)
6.	Google Prediction API (GPA):
    a.  Using GPA to build the model for regression analysis.
    b.  Pros: Easy to use; just upload data for model source and then build the model.
    c.  Cons: GAP offers only 2 types of analysis tool: regression and classification. Both tools require many observations          in order to make good prediction. And as expected, it took lots of time to build the model when more data was added.         They need the input data to be in an exact format: response be the first columns, while the remainings be the                predictors. There is no functionality of data partition as well as dimension reduction (even simple task like                ignoring some predictors in building the model). Also, there's no option for performing analysis with                        cross-vaildation.
    d.  Model Summary from GPA:
        200 OK
         
        - Hide headers -
         
        cache-control:  private, max-age=0, must-revalidate, no-transform
        content-encoding:  gzip
        content-length:  276
        content-type:  application/json; charset=UTF-8
        date:  Wed, 10 Jun 2015 14:57:14 GMT
        etag:  "gWxSu_DGSSSlZdDH28VQyEY69kY/mny4F_zqr1At7gDXkgIOF30qOxM"
        expires:  Wed, 10 Jun 2015 14:57:14 GMT
        server:  GSE
        vary:  Origin, X-Origin
         
        {
         "kind": "prediction#training",
         "id": "regressionshare",
         "selfLink": "https://www.googleapis.com/prediction/v1.6/projects/1076134286761/trainedmodels/regressionshare",
         "created": "2015-06-10T14:39:10.082Z",
         "trainingComplete": "2015-06-10T14:49:26.476Z",
         "modelInfo": {
          "numberInstances": "39644",
          "modelType": "regression",
          "meanSquaredError": "109035728.02"
         },
         "trainingStatus": "DONE"
        }

7.	R Script:
7.	


