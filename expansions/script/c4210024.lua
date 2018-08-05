--猫耳天堂-猫娘的证明
function c4210024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4210024.target)
	e1:SetOperation(c4210024.operation)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210024,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c4210024.rttg)
	e2:SetOperation(c4210024.rtop)
	c:RegisterEffect(e2)
	--return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210024,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)	
	e3:SetCode(0x1420042a)
	e3:SetRange(LOCATION_HAND)
	--e3:SetCost(c4210024.hdcost)
	e3:SetCondition(c4210024.hdcon)
	--e3:SetTarget(c4210024.hdtg)	
	e3:SetOperation(c4210024.hdop)
	c:RegisterEffect(e3)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c4210024.eqlimit)
	c:RegisterEffect(e4)
end
function c4210024.eqlimit(e,c)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c4210024.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR)
end
function c4210024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4210024.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4210024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c4210024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c4210024.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		local code = tc:GetCode()
		if code ~= 4210008 then
			tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
			tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		end
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		tc:RegisterFlagEffect(code,RESET_EVENT+0xcff0000,0,0)
	end
end
function c4210024.rtfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(4210010)==0
end
function c4210024.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c4210024.rtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4210024.rtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c4210024.rtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c4210024.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sel=1
	if Duel.IsChainDisablable(0) then		
		sel=Duel.SelectOption(tc:GetControler(),aux.Stringid(4210024,2),aux.Stringid(4210024,3))
		if sel==0 then
			Duel.PayLPCost(tc:GetControler(),500)
			Duel.NegateEffect(0)
			return false
		end
	end
	if sel==1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c4210024.cfilter(c,eg,e)
	return c:GetPreviousPosition(POS_FACEUP) 
		and e:GetHandler():GetPreviousPosition(POS_FACEUP) 
		and eg:IsContains(e:GetHandler()) 
end
function c4210024.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210024.cfilter,1,nil,eg,e) 
		and re:GetHandler():IsSetCard(0x2af)
end
function c4210024.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,4210024,RESET_PHASE+PHASE_END,0,0)
	if Duel.GetFlagEffect(tp,4210024)>=3 and Duel.CheckLPCost(tp,500) then Duel.PayLPCost(tp,500) end
	if Duel.GetFlagEffect(tp,4210024)>=5 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then 
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD) 
	end
	if Duel.GetFlagEffect(tp,4210024)>=7 and e:GetHandler():IsAbleToRemove() then Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) end
end
