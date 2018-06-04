--夏日休暇·爱丽丝
function c1160004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1160004.con1)
	e1:SetOperation(c1160004.op1)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetOperation(c1160004.op1)
	c:RegisterEffect(e2)
--  
	if not c1160004.gchk then
		c1160004.gchk=true
		c1160004[0]=10
		c1160004[1]=10
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(c1160004.con3)
		e3:SetOperation(c1160004.op3)
		Duel.RegisterEffect(e3,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+1160004)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c1160004.tg4)
	e4:SetOperation(c1160004.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,1160004)
	e5:SetTarget(c1160004.tg5)
	e5:SetOperation(c1160004.op5)
	c:RegisterEffect(e5)
--
end
--
function c1160004.con1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler())
end
--
function c1160004.ofilter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:GetLevel()==1
end
function c1160004.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1160004)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c1160004.ofilter1,tp,LOCATION_DECK,0,nil)>0 and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(1160004,0)) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c1160004.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
c1160004.count_available=1160004
--
function c1160004.chenk3(c)
	return c.count_available==1160004 and c:IsFaceup()
end
function c1160004.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1160004.check3,rp,0,LOCATION_ONFIELD,1,nil)
end
--
function c1160004.op3(e,tp,eg,ep,ev,re,r,rp)
	if c1160004[rp]<=1 then
		c1160004[rp]=10
		Duel.RaiseEvent(eg,EVENT_CUSTOM+1160004,re,r,rp,ep,ev)
	else
		c1160004[rp]=c1160004[rp]-1
	end
end
--
function c1160004.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==1-tp and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
--
function c1160004.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1160004)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1160004,1))  
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
function c1160004.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsPreviousLocation(LOCATION_MZONE) end
end
--
function c1160004.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1160004,2)) then
		local c=e:GetHandler()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--
		local e5_1=Effect.CreateEffect(c)
		e5_1:SetCode(EFFECT_CHANGE_TYPE)
		e5_1:SetType(EFFECT_TYPE_SINGLE)
		e5_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5_1:SetReset(RESET_EVENT+0x1fe0000)
		e5_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e5_1)
--
		local e5_2=Effect.CreateEffect(c)
		e5_2:SetType(EFFECT_TYPE_FIELD)
		e5_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e5_2:SetRange(LOCATION_SZONE)
		e5_2:SetTargetRange(LOCATION_MZONE,0)
		e5_2:SetCondition(c1160004.con5_2)
		e5_2:SetTarget(c1160004.tg5_2)
		e5_2:SetValue(1)
		e5_2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5_2)
		local e5_3=e5_2:Clone()
		e5_3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e5_3)
--
		local e5_4=Effect.CreateEffect(c)
		e5_4:SetType(EFFECT_TYPE_FIELD)
		e5_4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5_4:SetCode(EFFECT_CHANGE_DAMAGE)
		e5_4:SetRange(LOCATION_SZONE)
		e5_4:SetTargetRange(1,0)
		e5_4:SetCondition(c1160004.con5_2)
		e5_4:SetValue(c1160004.val5_4)
		c:RegisterEffect(e5_4)
		local e5_5=e5_4:Clone()
		e5_5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		c:RegisterEffect(e5_5)
--
	end
end
--
function c1160004.cfilter5_2(c)
	return c:IsFacedown() or c:GetLevel()~=1
end
function c1160004.con5_2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1160004.cfilter5_2,tp,LOCATION_MZONE,0,1,nil)
end
function c1160004.tg5_2(e,c)
	return c:IsFaceup()
end
--
function c1160004.val5_4(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
--