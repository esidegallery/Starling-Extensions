package starling.extensions.starlingCallLater
{
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;
	
	public class StarlingCallLater
	{
		/**
		 * 2D Array of vectors containing FunctionReference instances. 
		 * The indexes represent the number of frames ahead the functions will be called.
		 */
		private static var callStack:Array = [];
		
		/**
		 * Calls a function in a future frame.
		 * @param method The function to call.
		 * @param args An array of arguments that the function will be called with in order.
		 * @param nextFrameBut How far into the future (in frames) to call the function. Default is 0 i.e. the very next frame.
		 * @param allowDuplicate Whether identical functions already in the given frame are kept or removed. Default is false meaning that the function will only be called once in a given frame.
		 */
		public static function callLater(method:Function, args:Array = null, nextFrameBut:uint = 0, allowDuplicate:Boolean = false):void
		{
			if (!Boolean(method))
			{
				return;
			}
			
			if (!allowDuplicate)
			{
				clear(method);
			}
			
			var stage:Stage = Starling.current.stage;
			
			if (!stage)
			{
				method.apply(null, args);
			}
			else
			{
				if (callStack[nextFrameBut] == null)
				{
					callStack[nextFrameBut] = new Vector.<FunctionReference>;
				}
				
				callStack[nextFrameBut].push(new FunctionReference(method, args));
				
				if (!stage.hasEventListener(Event.ENTER_FRAME, stage_enterFrameHandler))
				{
					stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
				}
			}
		}
		
		/**
		 * Clears all entries of the passed function from the call stack, or all functions if no function is passed.
		 * @param method		The function reference to clear. Pass null to clear all pending methods.
		 * @param callCleared 	Whether to instantly call those functions cleared from the call stack.
		 */
		public static function clear(method:Function = null, callCleared:Boolean = false):void
		{
			var functionRef:FunctionReference;
			
			if (method != null)
			{
				for each (var functionRefs:Vector.<FunctionReference> in callStack)
				{
					if (!functionRefs)
					{
						continue;
					}
					for (var i:int = 0; i < functionRefs.length; i++)
					{
						functionRef = functionRefs[i];
						if (functionRef.method == method)
						{
							functionRefs.splice(i--, 1);
							if (callCleared)
							{
								functionRef.method.apply(null, functionRef.args);
							}
						}
					}
				}
			}
			else if (callCleared)
			{
				while (callStack.length)
				{
					functionRefs = callStack.shift() as Vector.<FunctionReference>;
					if (functionRefs)
					{
						while (functionRefs.length)
						{
							functionRef = functionRefs.shift();
							functionRef.method.apply(null, functionRef.args);
						}
					}
				}
			}
			else
			{
				callStack = [];
			}
			
			if (!callStack.length && Starling.current.stage)
			{
				Starling.current.stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			}
		}
		
		public static function methodIsQueued(method:Function):Boolean
		{
			for each (var functionRefs:Vector.<FunctionReference> in callStack)
			{
				if (functionRefs)
				{
					for (var i:int = 0; i < functionRefs.length; i++)
					{
						var functionRef:FunctionReference = functionRefs[i];
						if (functionRef.method == method)
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		private static function stage_enterFrameHandler(event:Event):void
		{
			var functionRefs:Vector.<FunctionReference>;
			if (callStack.length)
			{
				functionRefs = callStack.shift() as Vector.<FunctionReference>;
			}
			
			if (functionRefs)
			{
				while (functionRefs.length)
				{
					var functionRef:FunctionReference = functionRefs.shift();
					functionRef.method.apply(null, functionRef.args);
				}
			}
			
			if (!callStack.length)
			{
				event.target.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			}
		}
	}
	
}

class FunctionReference
{
	public var method:Function;
	public var args:Array;
	
	public function FunctionReference(method:Function, args:Array)
	{
		this.method = method;
		this.args = args;
	}
}