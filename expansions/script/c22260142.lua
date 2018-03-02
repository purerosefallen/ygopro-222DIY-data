--黑白 七夜志贵
function c22260142.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22260142,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c22260142.coincon)
	e1:SetTarget(c22260142.cointg)
	e1:SetOperation(c22260142.coinop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22260142.value)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1)
	e3:SetCondition(c22260142.con)
	e3:SetTarget(c22260142.tg)
	e3:SetOperation(c22260142.op)
	c:RegisterEffect(e3)
end
c22260142.toss_coin=true
c22260142.named_with_NanayaShiki=1
function c22260142.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22260142.ContainNanayaShiki(c)
	local m=_G["c"..c:GetOriginalCode()]
	return m and m.Desc_Contain_NanayaShiki
end
function c22260142.coincon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c22260142.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c22260142.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	res=Duel.TossCoin(tp,1)
	c22260142.arcanareg(c,res)
end
function c22260142.arcanareg(c,coin)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x17a0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
	--coin effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c22260142.spop1)
	e0:SetReset(RESET_EVENT+0x17a0000)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetCondition(c22260142.macon)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c22260142.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(36690018)~=0 then
		--spsummon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetOperation(c22260142.spop2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	e:Reset()
end
function c22260142.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22260142)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
function c22260142.macon(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c22260142.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c22260142.IsNanayaShiki(c)
end
function c22260142.value(e,c)
	return Duel.GetMatchingGroupCount(c22260142.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*700
end
function c22260142.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c22260142.filter(c)
	return c22260142.ContainNanayaShiki(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(false)
end
function c22260142.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22260142.filter,tp,LOCATION_DECK,0,1,1,nil) end
end
function c22260142.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22260142.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
