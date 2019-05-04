--葱喵亲卫队-幻想剑士
function c960012.initial_effect(c)
	c:SetSPSummonOnce(960012)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c960012.matfilter,1,1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(960012,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c960012.thtg)
	e3:SetOperation(c960012.thop)
	c:RegisterEffect(e3)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(960012,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c960012.condition)
	e1:SetOperation(c960012.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c960012.sumsuc)
	c:RegisterEffect(e8)
end
function c960012.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(960012,0)) 
end
function c960012.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and c:IsLinkSetCard(0xbb1)
end
function c960012.thfilter(c,tp)
	return c:IsSetCard(0xbb1) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c960012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c960012.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c960012.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c960012.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c960012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c960012.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsSetCard(0xbb1) and tc:IsRelateToBattle()
end
function c960012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local d=Duel.TossDice(tp,1)
	if not tc:IsRelateToBattle() or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(d*500)
	tc:RegisterEffect(e1)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(960012,1)) 
end
