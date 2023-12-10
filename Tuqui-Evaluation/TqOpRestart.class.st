Class {
	#name : #TqOpRestart,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpRestart >> acceptVisitor: visitor [
	^ visitor visitOpRestart: self
]
