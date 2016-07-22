#!/usr/bin/env python
"""
Implement your own version of logistic regression with stochastic
gradient descent.

Author: <your_name>
Email : <your_email>
"""

import collections
import math


class LogisticRegressionSGD:

    def __init__(self, eta, mu, n_feature):
        """
        Initialization of model parameters
        """
        self.eta = eta
        self.mu=mu
        self.weight = [0.0] * n_feature


    def fit(self, X, y):
		"""
		Update model using a pair of training sample
		"""
		#print (len(self.weight))
		#print X
		#a = self.predict_prob(self, X)
		
		
		#print a
		# for f, v in X:
			# print f
		# print type(y-a)
		# print a
		# print X[10][1]     
		grad =[0.0]*len(self.weight)
		
		#print 'bla'
		#print len(grad)
		
		a = 1.0 / (1.0 + math.exp(-math.fsum([self.weight[f]*v for f, v in X])))
		 
		b=self.eta*(y-a)
		c=1-self.mu*self.eta
		for f, v in X:

			self.weight[f]= c*self.weight[f]+b*v
			#print grad
			#print self.weight
		#print len(self.weight)
		#s=[self.weight[f]*v for f, v in X]
		#print s
		pass
		
    def predict(self, X):
        return 1 if predict_prob(self, X) > 0.5 else 0

    def predict_prob(self, X):
        return  1.0 / (1.0 + math.exp(-math.fsum([self.weight[f]*v for f, v in X])))
