Class {
	#name : #TqOpNonLocalReturn,
	#superclass : #TqOpReturn,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpNonLocalReturn >> acceptVisitor: visitor [
	^ visitor visitOpNonLocalReturn: self
]
