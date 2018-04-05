--那对主仆的日常
function c22261003.initial_effect(c)
	--ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22261003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22261003.target)
	e1:SetOperation(c22261003.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22261003,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22261003.con)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c22261003.op)
	c:RegisterEffect(e2)
end
c22261003.Desc_Contain_NanayaShiki=1
function c22261003.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22261003.filter1(c,e,tp)
	return c:IsCode(22260007) and c:IsFaceup() and Duel.IsPlayerCanDraw(tp,1) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22261003.filter2,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c22261003.filter2(c,e,tp)
	return c22261003.IsNanayaShiki(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22261003.filter3(c,tp)
	local g=c:GetColumnGroup():Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsControler,nil,1-tp)
	return c22261003.IsNanayaShiki(c) and c:IsFaceup() and Duel.IsExistingMatchingCard(c22261003.filter4,tp,LOCATION_DECK,0,1,nil) and g:GetCount()>0
end
function c22261003.filter4(c)
	return c:IsCode(22260007) and c:IsAbleToHand()
end
function c22261003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(c22261003.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c22261003.filter3,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(22261003,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(22261003,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c22261003.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)	  
	elseif sel==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c22261003.filter3,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local dg=g:GetFirst():GetColumnGroup():Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsControler,nil,1-tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),1-tp,LOCATION_MZONE)
	end
end
function c22261003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsCode(22260007) then
		if Duel.GetMZoneCount(tp)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c22261003.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	elseif c22261003.IsNanayaShiki(tc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hc=Duel.SelectMatchingCard(tp,c22261003.filter4,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if hc then 
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
			if tc:IsRelateToEffect(e) then
				local dg=tc:GetColumnGroup():Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsControler,nil,1-tp)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c22261003.cfilter2(c,tp)
	return c:IsCode(22260007) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c22261003.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c22261003.IsNanayaShiki(c) and c:GetMaterial():FilterCount(c22261003.cfilter2,nil,tp)>0
end
function c22261003.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22261003.cfilter,1,nil,tp)
end
function c22261003.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c22261003.cfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(22261003,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c22261003.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22261003.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end