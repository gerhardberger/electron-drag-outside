#import <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>
#import <objc/runtime.h>

#include <napi.h>

static IMP g_originalRightMouseDown;
static IMP g_originalOtherMouseDown;
static IMP g_originalMouseEvent;

void swizzledRightMouseDown(id obj, SEL sel, NSEvent* theEvent) {
  BOOL yes = YES;
  object_setInstanceVariable(obj, "_dragging", &yes);

  ((void(*) (id, SEL, NSEvent*))g_originalRightMouseDown)(obj, sel, theEvent);
}

void swizzledOtherMouseDown(id obj, SEL sel, NSEvent* theEvent) {
  BOOL yes = YES;
  object_setInstanceVariable(obj, "_dragging", &yes);

  ((void(*) (id, SEL, NSEvent*))g_originalOtherMouseDown)(obj, sel, theEvent);
}

void swizzledMouseEvent(id obj, SEL sel, NSEvent* theEvent) {
  ((void(*) (id, SEL, NSEvent*))g_originalMouseEvent)(obj, sel, theEvent);

  NSEventType type = [theEvent type];
  if (type == NSEventTypeLeftMouseDown || type == NSEventTypeRightMouseDown || type == NSEventTypeOtherMouseDown) {
    BOOL yes = YES;
    object_setInstanceVariable(obj, "_hasOpenMouseDown", &yes);
  } else if (type == NSEventTypeLeftMouseUp || type == NSEventTypeRightMouseUp || type == NSEventTypeOtherMouseUp) {
    BOOL no = NO;
    object_setInstanceVariable(obj, "_hasOpenMouseDown", &no);
  }
}

void Setup(const Napi::CallbackInfo &info) {
  auto rightMouseDownMethod = class_getInstanceMethod(
    NSClassFromString(@"BaseView"),
    NSSelectorFromString(@"rightMouseDown:"));

  g_originalRightMouseDown = method_setImplementation(rightMouseDownMethod,
    (IMP)&swizzledRightMouseDown);

  auto otherMouseDownMethod = class_getInstanceMethod(
    NSClassFromString(@"BaseView"),
    NSSelectorFromString(@"otherMouseDown:"));

  g_originalOtherMouseDown = method_setImplementation(otherMouseDownMethod,
    (IMP)&swizzledOtherMouseDown);

  auto mouseEventMethod = class_getInstanceMethod(
    NSClassFromString(@"RenderWidgetHostViewCocoa"),
    NSSelectorFromString(@"mouseEvent:"));

  g_originalMouseEvent = method_setImplementation(mouseEventMethod,
    (IMP)&swizzledMouseEvent);
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set(Napi::String::New(env, "setup"),
              Napi::Function::New(env, Setup));

  return exports;
}

NODE_API_MODULE(electron_drag_outside, Init)
