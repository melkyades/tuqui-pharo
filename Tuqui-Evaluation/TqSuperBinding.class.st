Class {
	#name : #TqSuperBinding,
	#superclass : #TqSelfBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #testing }
TqSuperBinding >> isSelf [
	^false
]

{ #category : #testing }
TqSuperBinding >> isSuper [
	^true
]

{ #category : #testing }
TqSuperBinding >> printOn: aStream [
	aStream nextPutAll: 'SuperId'
]
