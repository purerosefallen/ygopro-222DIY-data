--贤者 姬塔
function c47500013.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47500012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c47500013.target)
	e1:SetOperation(c47500013.activate)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c47500013.discon2)
	e2:SetOperation(c47500013.disop2)
	c:RegisterEffect(e2)   
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,47500014)
	e3:SetCondition(c47500013.hspcon)
	e3:SetOperation(c47500013.hspop)
	c:RegisterEffect(e3)   
	local e4=e3:Clone()
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(c47500013.hspcon1)
	e4:SetOperation(c47500013.hspop1)
	c:RegisterEffect(e4)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c47500013.sumsuc)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCondition(c47500013.condition)
	e6:SetOperation(c47500013.operation)
	c:RegisterEffect(e6)
	--code
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CHANGE_CODE)
	e7:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
	e7:SetValue(47500000)
	c:RegisterEffect(e7)
end
c47500013.list={
		CATEGORY_DESTROY,
		CATEGORY_RELEASE,
		CATEGORY_REMOVE,
		CATEGORY_TOHAND,
		CATEGORY_TODECK,
		CATEGORY_TOGRAVE,
		CATEGORY_DECKDES,
		CATEGORY_HANDES,
		CATEGORY_POSITION,
		CATEGORY_CONTROL,
		CATEGORY_DISABLE,
		CATEGORY_DISABLE_SUMMON,
		CATEGORY_EQUIP,
		CATEGORY_DAMAGE,
		CATEGORY_RECOVER,
		CATEGORY_ATKCHANGE,
		CATEGORY_DEFCHANGE,
		CATEGORY_COUNTER,
		CATEGORY_LVCHANGE,
		CATEGORY_NEGATE,
}
c47500013.card_code_list={47500000}
function c47500013.filter(c)
	return c:IsCode(47500015) and c:IsAbleToHand()
end
function c47500013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47500013.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47500013.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47500013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47500013.nfilter(c)
	return c:IsCode(47500000) and c:IsLocation(LOCATION_ONFIELD)
end
function c47500013.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not rp==1-tp then return end
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if c47500013.nfilter(re:GetHandler()) then return true end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsExists(c47500013.nfilter,1,nil) then return true end
	local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
	if res and ceg and ceg:IsExists(c47500013.nfilter,1,nil) then return true end
	for i,ctg in pairs(c47500013.list) do
		local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
		if tg then
			if tg:IsExists(c47500013.nfilter,1,c) then return true end
		elseif v and v>0 and Duel.IsExistingMatchingCard(c47500013.nfilter,tp,v,0,1,nil) then
			return true
		end
	end
	return false
end
function c47500013.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c47500013.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsCode(47500000) and not c:IsForbidden()
end
function c47500013.tefilter1(c)
	return c:IsType(TYPE_PENDULUM) and c:GetOriginalCode()==47500000 and not c:IsForbidden()
end
function c47500013.hspcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c47500013.tefilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c47500013.hspop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500013,0))
	local g=Duel.SelectMatchingCard(tp,c47500013.tefilter1,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
end
function c47500013.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c47500013.tefilter,tp,LOCATION_PZONE,0,1,nil)
end
function c47500013.hspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500013,0))
	local g=Duel.SelectMatchingCard(tp,c47500013.tefilter,tp,LOCATION_PZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
end
function c47500013.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c47500013.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47500013.actlimit(e,te,tp)
	return te:GetHandler():IsType(TYPE_COUNTER)
end
function c47500013.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c47500013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c47500013.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end