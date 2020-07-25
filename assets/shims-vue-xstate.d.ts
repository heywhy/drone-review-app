declare module '@vue/xstate' {
  import { Ref } from 'vue'
  import {
    EventObject,
    StateMachine,
    State,
    Interpreter,
    InterpreterOptions,
    MachineOptions,
    StateConfig
  } from 'xstate';

  interface UseMachineOptions<TContext, TEvent extends EventObject> {
    /**
     * If provided, will be merged with machine's `context`.
     */
    context?: Partial<TContext>;
    /**
     * The state to rehydrate the machine to. The machine will
     * start at this state instead of its `initialState`.
     */
    state?: StateConfig<TContext, TEvent>;
  }

  export function useMachine<TContext, TEvent extends EventObject>(
    machine: StateMachine<TContext, any, TEvent>,
    options?: Partial<InterpreterOptions> &
      Partial<UseMachineOptions<TContext, TEvent>> &
      Partial<MachineOptions<TContext, TEvent>>
  ): {
    state: Ref<State<TContext, TEvent>>;
    send: Interpreter<TContext, any, TEvent>['send'];
    service: Interpreter<TContext, any, TEvent>;
  };

  export function useService<TContext, TEvent extends EventObject>(
    service:
      | Interpreter<TContext, any, TEvent>
      | Ref<Interpreter<TContext, any, TEvent>>
  ): {
    state: Ref<State<TContext, TEvent>>;
    send: Interpreter<TContext, any, TEvent>['send'];
    service: Ref<Interpreter<TContext, any, TEvent>>;
  };
}
