--星灵符·虎
function c69696917.initial_effect(c)
	if not c69696917.global_check then 
		c69696917.global_check=true
		--adjust
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EVENT_ADJUST)
		e5:SetOperation(c69696917.adjustop)
		Duel.RegisterEffect(e5,tp)
	end 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69696917+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c69696917.target)
	e1:SetOperation(c69696917.activate)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--destroy/to hand replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c69696917.desreptg)
	e3:SetOperation(c69696917.desrepop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(c69696917.threptg)
	e4:SetValue(c69696917.threpval)
	c:RegisterEffect(e4)
end
function c69696917.ewfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelAbove(5) and c:IsSummonableCard() and c:GetFlagEffect(69696917)==0
end
function c69696917.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local g=Duel.GetMatchingGroup(c69696917.ewfilter,tp,LOCATION_HAND,0,nil)
	local tc=g:GetFirst()
	if g:GetCount()==0 then return end 
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetTarget(c69696917.stg)
		e1:SetCondition(c69696917.scon)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetValue(POS_FACEUP_ATTACK)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(69696917,RESET_EVENT+0x1ff0000,0,0)
		tc=g:GetNext()
	end 
end
function c69696917.stg(e,c)
   return c~=e:GetHandler()
end
function c69696917.scon(e,c)
   return Duel.GetFlagEffect(tp,696969171)>0
end
function c69696917.filter(c)
	return (c:GetFlagEffect(69696917)>0 or c:IsSummonable(true,nil,0)) and c:IsType(TYPE_SPIRIT) and not c:IsPublic()
end
function c69696917.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69696917.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c69696917.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,696969171,EVENT_CHAIN_END,0,1) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c69696917.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Summon(tp,g:GetFirst(),true,nil)~=0 then
		   Duel.Equip(tp,e:GetHandler(),g:GetFirst())
		   --Add Equip limit
		   local e1=Effect.CreateEffect(g:GetFirst())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetCode(EFFECT_EQUIP_LIMIT)
		   e1:SetValue(c69696917.eqlimit)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e:GetHandler():RegisterEffect(e1)
		end
	Duel.ResetFlagEffect(tp,696969171)
	end
end
function c69696917.eqlimit(e,c)
	return e:GetOwner()==c
end
function c69696917.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) and not tg:IsReason(REASON_REPLACE)
		and c:IsAbleToHand() and tg:IsCanTurnSet() end
	return Duel.SelectYesNo(tp,aux.Stringid(69696917,0))
end
function c69696917.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.RaiseEvent(c,EVENT_TO_HAND,e,REASON_EFFECT,tp,tp,0)
	Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
end
function c69696917.threptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return tg:IsControler(tp) and tg:IsLocation(LOCATION_ONFIELD) and tg:GetDestination()==LOCATION_HAND and not tg:IsReason(REASON_REPLACE) and c:IsAbleToHand() and tg:IsCanTurnSet() end
	if Duel.SelectYesNo(tp,aux.Stringid(69696917,1)) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.RaiseEvent(c,EVENT_TO_HAND,e,REASON_EFFECT,tp,tp,0)
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
		return true
	else return false end
end
function c69696917.threpval(e,c)
	return false
end
