local m=33330221
local cm=_G["c"..m]
cm.name="境界交错 幻影"
--配 置 信 息
cm.set=0x55a	--字 段
cm.IsMirrorCross=true   --内 置 字 段

cm.level=4

function cm.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Level 4
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.level)
	c:RegisterEffect(e1)
end
function cm.isset(c)
	return c:IsSetCard(cm.set) or c.IsMirrorCross
end
--Level 4
function cm.lvtg(e,c)
	return cm.isset(c) and c:IsType(TYPE_MONSTER)
end