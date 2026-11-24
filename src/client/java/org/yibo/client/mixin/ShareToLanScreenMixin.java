package org.yibo.client.mixin;

import net.minecraft.client.gui.components.CycleButton;
import net.minecraft.client.gui.components.Tooltip;
import net.minecraft.client.gui.screens.ShareToLanScreen;
import net.minecraft.network.chat.Component;
import net.minecraft.network.chat.contents.TranslatableContents;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(ShareToLanScreen.class)
public class ShareToLanScreenMixin {
    @Shadow
    private boolean commands; // 是否允许命令？

    @Inject(method = "init", at = @At("TAIL"))
    private void disableAllowCommandsButton(CallbackInfo ci) {
        ShareToLanScreen screen = (ShareToLanScreen) (Object) this;

        // 查找“允许命令”按钮
        for (var element : screen.children()) {
            if (
                element instanceof CycleButton<?> cycleButton &&
                cycleButton.getValue() instanceof Boolean
            ) {
                Component buttonName = ((CycleButtonAccessor) cycleButton).getName();
                if (
                    buttonName.getContents() instanceof TranslatableContents translatable &&
                    translatable.getKey().equals("selectWorld.allowCommands")
                ) {
                    @SuppressWarnings("unchecked")
                    CycleButton<Boolean> allowCommandsButton = (CycleButton<Boolean>) cycleButton;

                    // 如果禁用命令，则将按钮强制设为 false 并置灰禁用
                    if (!commands) {
                        allowCommandsButton.setValue(false);
                        allowCommandsButton.active = false;

                        // 创建提示文本组件
                        Component tooltipMessage = Component.translatable("nolobbycheats.gui.allowCommands.disabled_hint");
                        allowCommandsButton.setTooltip(Tooltip.create(tooltipMessage));
                    }
                    break;
                }
            }

        }
    }
}

