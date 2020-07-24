import hotkeys, {HotkeysEvent, KeyHandler} from "hotkeys-js";
import { onUnmounted, ref, Ref, VNode } from 'vue'

type AvailableTags = 'INPUT' | 'TEXTAREA' | 'SELECT';

export type Options = {
  filter?: typeof hotkeys.filter;
  enableOnTags?: AvailableTags[];
  splitKey?: string;
  scope?: string;
  keyup?: boolean;
  keydown?: boolean;
};

export const useHotKeys = <T extends Element>(keys: string, callback: KeyHandler, options?: Options) => {
  const elRef = ref<T | null>(null)
  const {enableOnTags, filter} = options || {};

  if (options?.enableOnTags) {
    hotkeys.filter = ({target, srcElement}) => {
      // @ts-ignore
      const targetTagName = (target && target.tagName) || (srcElement && srcElement.tagName);

      return Boolean(targetTagName && enableOnTags && enableOnTags.includes(targetTagName as AvailableTags));
    };
  }

  if (filter) hotkeys.filter = filter;

  hotkeys(keys, options || {}, (keyboardEvent: KeyboardEvent, hotkeysEvent: HotkeysEvent) => {
    if (elRef.value === null || document.activeElement === elRef.value) {
      callback(keyboardEvent, hotkeysEvent);
      return true;
    }

    return false;
  });

  onUnmounted(() => hotkeys.unbind(keys))

  return elRef
}
