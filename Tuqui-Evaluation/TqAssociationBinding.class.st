Class {
	#name : #TqAssociationBinding,
	#superclass : #TqBinding,
	#instVars : [
		'index',
		'association'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #testing }
TqAssociationBinding >> assign: value within: anEvaluationContext [
	anEvaluationContext storeAssociation: association value: value
]

{ #category : #accessing }
TqAssociationBinding >> association [
	^association
]

{ #category : #accessing }
TqAssociationBinding >> association: anAssociation [
	association := anAssociation
]

{ #category : #testing }
TqAssociationBinding >> index [ 
	^ index
]

{ #category : #testing }
TqAssociationBinding >> index: anInteger [
	 index := anInteger 
]

{ #category : #testing }
TqAssociationBinding >> isAssociation [
	^true
]

{ #category : #testing }
TqAssociationBinding >> isConstant [
	^ false
]

{ #category : #testing }
TqAssociationBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext loadAssociationValue: association
]
