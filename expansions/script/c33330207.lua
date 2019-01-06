local m=33330207
local cm=_G["c"..m]
cm.name="境界交错 归去之舟"
--配 置 信 息
cm.set=0x55a	--字 段
cm.IsMirrorCross=true   --内 置 字 段

function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,cm.mfilter,2,2)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.etarget)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--Destroy & Atk Up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.isset(c)
	return c:IsSetCard(cm.set) or c.IsMirrorCross
end
--Link Summon
function cm.mfilter(c)
	return cm.isset(c)
end
--Immune
function cm.etarget(e,c)
	return c:IsFaceup() and cm.isset(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.efilter(e,re)
	return not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
--Destroy & Atk Up
function cm.desfilter(c)
	return c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end