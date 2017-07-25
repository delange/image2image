
# image2image
Search images with  image featurization and pre-trained deep learning models

The provided R script performs an image to image search.

The solution makes use of Microsoft R Server and MicrosoftML library. However, for development purpose the free Microsoft R Client is suffiecent enough. Instructions how to install Microsoft R Client can be found for different platforms at:


https://docs.microsoft.com/en-us/r-server/install/r-server-install-supported-platforms

	
For Windows: https://docs.microsoft.com/en-us/r-server/r-client/install-on-windows

		
For Linux: https://docs.microsoft.com/en-us/r-server/r-client/install-on-linux

		
                
Make sure you add the following components that are installed as part of Microsoft R Client: pretrained models. 

  see also : https://docs.microsoft.com/en-us/r-server/install/microsoftml-install-pretrained-models
 
 The MicrosoftML library includes the used Featurize Image transform:
 
 https://docs.microsoft.com/en-us/r-server/r-reference/microsoftml/featurizeimage
