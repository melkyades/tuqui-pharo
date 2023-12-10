Class {
	#name : #TqOpLoadRwithNil,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpLoadRwithNil >> acceptVisitor: visitor [
	^ visitor visitOpLoadRwithNil: self
]
