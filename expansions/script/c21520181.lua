--奇形异阵
function c21520181.initial_effect(c)
	--active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520181,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,21520181)
	e2:SetCondition(c21520181.thcon)
	e2:SetTarget(c21520181.thtg)
	e2:SetOperation(c21520181.thop)
	c:RegisterEffect(e2)
--[[	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520181,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21520181)
	e3:SetCondition(c21520181.drcon)
	e3:SetTarget(c21520181.drtg)
	e3:SetOperation(c21520181.drop)
	c:RegisterEffect(e3)--]]
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c21520181.reptg)
	e4:SetValue(c21520181.repval)
	c:RegisterEffect(e4)
	--atk & def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x490))
	e5:SetValue(c21520181.adval)
	c:RegisterEffect(e5)
	local e5_2=e5:Clone()
	e5_2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5_2)
end
function c21520181.confilter(c,tp)
	return c:IsSetCard(0x490) and c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE
end
function c21520181.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c21520181.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520181.confilter,1,nil,tp)
end
function c21520181.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520181.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520181.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsOnField() and e:GetHandler():IsFaceup()) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520181.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21520181.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_DESTROY) 
		and c:IsSetCard(0x490) and c:GetControler()==tp and c:IsLevelBelow(10) and not c:IsType(TYPE_FUSION) and c:GetOriginalCode()~=21520180
end
function c21520181.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local count=eg:FilterCount(c21520181.repfilter,nil,tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=count
	end
	if Duel.SelectYesNo(tp,aux.Stringid(21520181,1)) then
		local reptype=nil
		local ct=0
		local g=eg:Filter(c21520181.repfilter,nil,tp)
		local tc=g:GetFirst()
		while tc do
			if tc:IsSetCard(0x5490) then 
				reptype=TYPE_SPELL+TYPE_CONTINUOUS
				ct=2
			else 
				reptype=TYPE_TRAP+TYPE_CONTINUOUS 
				ct=3
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc:CancelToGrave()
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(21520181,ct))
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0xfc0000)
--			if tc:IsSetCard(0x5490) then e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
--			else e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS) end
			e1:SetValue(reptype)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_DESTROYED,e,0,0,0,0)
		return true
	else return false end
end
function c21520181.repval(e,c)
--	return true
	return c:IsSetCard(0x490) and c:GetControler()==e:GetHandlerPlayer() and c:IsLevelBelow(10) and not c:IsType(TYPE_FUSION)
end
function c21520181.adfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520181.adval(e,c)
	return Duel.GetMatchingGroupCount(c21520181.adfilter,c:GetControler(),LOCATION_SZONE,0,nil)*300
end
--[[
function c21520181.drfilter(c,tp)
	return c:IsSetCard(0x490) and c:IsControler(tp) and ((c:IsPreviousPosition(POS_FACEUP_ATTACK) and c:IsPosition(POS_FACEUP_DEFENSE)) 
		or (c:IsPreviousPosition(POS_FACEUP_DEFENSE) and c:IsPosition(POS_FACEUP_ATTACK)))
end
function c21520181.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520181.drfilter,1,nil,tp)
end
function c21520181.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW+CATEGORY_TODECK,nil,0,tp,0)
end
function c21520181.dfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520181.drop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsOnField() and e:GetHandler():IsFaceup()) then return end
	local ct=Duel.GetMatchingGroupCount(c21520181.dfilter,tp,LOCATION_MZONE,0,nil)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dc<ct then return end
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.BreakEffect()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,ct,ct,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
end--]]
