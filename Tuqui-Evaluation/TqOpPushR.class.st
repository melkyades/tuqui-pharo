Class {
	#name : #TqOpPushR,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpPushR >> acceptVisitor: visitor [
	^ visitor visitOpPushR: self
]
