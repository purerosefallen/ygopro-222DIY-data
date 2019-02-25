--劍冑 二世村正
function c62501008.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,62501008),LOCATION_SZONE)
 --   local e0=Effect.CreateEffect(c)
 --   e0:SetType(EFFECT_TYPE_ACTIVATE)
 ---   e0:SetCode(EVENT_FREE_CHAIN)
 --   c:RegisterEffect(e0)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(62501008,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c62501008.discost)
	e1:SetCondition(c62501008.condition)
	e1:SetTarget(c62501008.target)
	e1:SetOperation(c62501008.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501008,1))
   -- e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
 --   e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
   -- e2:SetCountLimit(1,10109103)
--  e2:SetCost(c10109003.spcost)
--  e2:SetTarget(c10109003.sptg)
	e2:SetCondition(c62501008.spon)
	e2:SetCost(c62501008.spop)
	c:RegisterEffect(e2) 
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(62501008,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,62501008)
 --   e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
 --   e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(c62501008.atktg)
	e3:SetCost(c62501008.cost)
	e3:SetOperation(c62501008.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62501008,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c62501008.necost)
	e4:SetCondition(c62501008.condition)
	e4:SetTarget(c62501008.netg)
	e4:SetOperation(c62501008.activate)
	c:RegisterEffect(e4)   
end
function c62501008.repcon(e)
	local c=e:GetHandler()
	return  c:IsLocation(LOCATION_HAND) 
end
function c62501008.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
 --   e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
 --   Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
end

function c62501008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c62501008.atfilter(c)
	return  c:IsSetCard(0x625) 
end
function c62501008.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsControler(tp) and c62501008.atfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62501008.atfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c62501008.atfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c62501008.filter1(c,tp)
	return  c:IsAbleToRemove()   
end
function c62501008.gvfilter(c,e,tp)
	return c:IsDefenseBelow(400) and c:IsRace(RACE_WARRIOR)
end

function c62501008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e3)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,62501013,0x620,0x4011,2000,2000,7,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,62501013)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c62501008.filter(c,p)
	return  c:IsOnField()
end
function c62501008.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c62501008.filter,nil,tp)-tg:GetCount()>1
end
function c62501008.sfilter(c,e,tp)
	return c:IsCode(62501008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62501008.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c62501008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c62501008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local sc=Duel.GetFirstMatchingCard(c62501008.sfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if sc and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(62501008,3)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c62501008.spon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c62501008.filter,nil,tp)-tg:GetCount()>1
end
function c62501008.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() end
	   if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		 
	   end
end
function c62501008.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c62501008.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c62501008.cofilter(c)
	return c:IsFaceup() and c:IsSetCard(0x624) 
end
function c62501008.spon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c62501008.cofilter,tp,LOCATION_SZONE,0,1,nil)
end
function c62501008.neop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end