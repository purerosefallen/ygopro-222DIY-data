--不可思议的炼金工作室
function c4212312.initial_effect(c)
	c:SetUniqueOnField(1,0,4212312)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212312,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c4212312.tfop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212312,1))  
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c4212312.tg)
	e2:SetOperation(c4212312.op)
	c:RegisterEffect(e2)
end
function c4212312.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x2a5) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c4212312.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c4212312.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212312,1)) then
			local ct=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),2)
			local g=Duel.SelectMatchingCard(tp,c4212312.tffilter,tp,LOCATION_GRAVE,0,1,ct,nil,tp)
			if g:GetCount()<=0 then return end
			if ct<1 then return end
			if g:GetCount()>ct then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				g=g:Select(tp,1,ct,nil)
			end
			for tc in aux.Next(g) do
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end
function c4212312.filter1(c,e)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x2a5)
end
function c4212312.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() 
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsType(TYPE_SPELL) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4212312.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		if not Duel.IsExistingMatchingCard(c4212312.filter1,tp,LOCATION_GRAVE,0,2,nil) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(4212312,2)) then
			local tg=Duel.SelectMatchingCard(tp,c4212312.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
			if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
