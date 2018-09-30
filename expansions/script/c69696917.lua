--星灵符·虎
function c69696917.initial_effect(c)
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
function c69696917.filter(c)
	return c:IsSummonable(true,nil,0) and c:IsType(TYPE_SPIRIT)
end
function c69696917.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69696917.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c69696917.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
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
