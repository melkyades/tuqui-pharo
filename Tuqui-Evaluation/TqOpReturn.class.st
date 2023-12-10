Class {
	#name : #TqOpReturn,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpReturn >> acceptVisitor: visitor [
	^ visitor visitOpReturn: self
]
