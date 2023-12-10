Class {
	#name : #TqOpLoadRwithSelf,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpLoadRwithSelf >> acceptVisitor: visitor [
	^ visitor visitOpLoadRwithSelf: self
]
