--伞符『单脚投手返』
local m=1141103
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Umbrella=true
--
function c1141103.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1141103.tg1)
	e1:SetOperation(c1141103.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c1141103.con2)
	e2:SetTarget(c1141103.tg2)
	e2:SetOperation(c1141103.op2)
	c:RegisterEffect(e2)
--
end
--
c1141103.muxu_ih_KTatara=1
--
function c1141103.tfilter1(c)
	return muxu.check_set_Tatara(c) and c:IsAbleToHand()
end
--
function c1141103.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1141103.tfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1141103.ofilter1(c,seq)
	return c:GetSequence()>seq and c.muxu_ih_KTatara and not c:IsType(TYPE_MONSTER)
end
function c1141103.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local sg=Duel.GetMatchingGroup(c1141103.tfilter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=sg:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=sg:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		else
			if Duel.SendtoHand(spcard,nil,REASON_EFFECT)>0 then
				local lg=Duel.GetMatchingGroup(c1141103.ofilter1,tp,LOCATION_DECK,0,nil,seq)
				if lg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1141103,0)) then
					local tg=lg:Select(tp,1,1,nil)
					Duel.BreakEffect()
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tg)
					Duel.ShuffleDeck(tp)
					Duel.ShuffleHand(tp)
				end
			end
		end
	else
		Duel.ShuffleDeck(tp)
	end
end
--
function c1141103.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x4040)~=0 and c:IsPreviousLocation(LOCATION_HAND)
end
--
function c1141103.tfilter2(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c1141103.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1141103.tfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1141103.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c1141103.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
--
function c1141103.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsPosition(POS_FACEUP_DEFENSE) then return end
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)<1 then return end
	local sg=tc:GetColumnGroup()
	local lg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if lg:GetCount()<1 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1141103,1)) then
		Duel.BreakEffect()
		Duel.SendtoHand(lg,nil,REASON_EFFECT)
	end
end
--
