Class {
	#name : #TqOpDropToS,
	#superclass : #TqOperation,
	#instVars : [
		'count'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpDropToS >> acceptVisitor: visitor [
	^ visitor visitOpDropToS: self
]

{ #category : #visiting }
TqOpDropToS >> count [
	^count
]

{ #category : #visiting }
TqOpDropToS >> count: anInteger [
	count := anInteger 
]
