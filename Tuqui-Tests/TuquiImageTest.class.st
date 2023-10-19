Class {
	#name : #TuquiImageTest,
	#superclass : #TestCase,
	#instVars : [
		'image',
		'bootstrapper'
	],
	#category : #'Tuqui-Tests'
}

{ #category : #tests }
TuquiImageTest >> setUp [
	bootstrapper := TuquiRingBootstrapper new.
	image := bootstrapper genesis image
]

{ #category : #tests }
TuquiImageTest >> test010nil [

	| nilObj nilBehavior class classname nilClass |
	nilObj := image nil.
	nilBehavior := bootstrapper spec2behavior: 
		               bootstrapper => #UndefinedObject.
	self assert: nilObj behavior equals: nilBehavior.
	nilClass := bootstrapper ivarOf: nilObj behavior named: #class.
	class := bootstrapper classNamed: #UndefinedObject.
	classname := bootstrapper ivarOf: class named: #name.

	self
		assert: nilObj size equals: 0;
		assert: nilClass equals: class;
		assert: classname asLocalString equals: 'UndefinedObject'
]

{ #category : #tests }
TuquiImageTest >> test020true [

	| trueObj trueBehavior trueClass class classname  |
	trueObj := image true.
	trueBehavior := bootstrapper spec2behavior: bootstrapper => #True.
	self assert: trueObj behavior equals: trueBehavior.
	trueClass := bootstrapper ivarOf: trueObj behavior named: #class.
	class := bootstrapper classNamed: #True.
	classname := bootstrapper ivarOf: class named: #name.

	self
		assert: trueObj size equals: 0;
		assert: trueClass equals: class;
		assert: classname asLocalString equals: 'True'
]

{ #category : #tests }
TuquiImageTest >> test030false [

	| falseObj falseBehavior falseClass class classname |
	falseObj := image false.
	falseBehavior := bootstrapper spec2behavior: bootstrapper => #False.
	self assert: falseObj behavior equals: falseBehavior.
	falseClass := bootstrapper ivarOf: falseObj behavior named: #class.
	class := bootstrapper classNamed: #False.
	classname := bootstrapper ivarOf: class named: #name.

	self
		assert: falseObj size equals: 0;
		assert: falseClass equals: class;
		assert: classname asLocalString equals: 'False'
]

{ #category : #tests }
TuquiImageTest >> test040superclasses [

	| proto object collection class metaproto |
	proto := bootstrapper classNamed: #ProtoObject.
	object := bootstrapper classNamed: #Object.
	collection := bootstrapper classNamed: #Collection.
	class := bootstrapper classNamed: #Class.
	metaproto := bootstrapper ivarOf: proto behavior named: #class.
	self
		assert: (bootstrapper ivarOf: proto named: #superclass) equals: image nil;
		assert: (bootstrapper ivarOf: object named: #superclass) equals: proto;
		assert: (bootstrapper ivarOf: collection named: #superclass) equals: object;
		assert: (bootstrapper ivarOf: metaproto named: #superclass) equals: class
]

{ #category : #tests }
TuquiImageTest >> test050metaclasses [

	| spec proto metaproto |
	spec := bootstrapper => #ProtoObject.
	proto := bootstrapper classFor: spec.
	metaproto := bootstrapper metaclassFor: spec metaclass.
	self assert: (bootstrapper ivarOf: metaproto named: #class) equals: proto
]

{ #category : #tests }
TuquiImageTest >> test100yourself [

	| spec proto behavior md yourself |
	spec := bootstrapper => #ProtoObject.
	proto := bootstrapper classFor: spec.
	behavior := bootstrapper ivarOf: proto named: #instanceBehavior.
	md := bootstrapper ivarOf: behavior named: #methods.
	yourself := bootstrapper addSymbol: #yourself.
	self assert: (md includesKey: yourself)
]
