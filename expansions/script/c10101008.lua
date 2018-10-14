--苍翼佣兵团 希达
function c10101008.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10101008,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10101008)
	e1:SetTarget(c10101008.rmtg)
	e1:SetOperation(c10101008.rmop)
	c:RegisterEffect(e1)  
	--tograveorremove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10101008,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10101108)
	e2:SetTarget(c10101008.tdtg)
	e2:SetOperation(c10101008.tdop)
	c:RegisterEffect(e2)   
end
function c10101008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10101008.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10101008.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101008,3))
	   local tc=Duel.SelectMatchingCard(tp,c10101008.tdfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	   if tc then
		  local op1,op2=false,false
		  if tc:IsAbleToRemove() then op2=true end
		  if tc:IsAbleToGrave() then op1=true end
		  if op1 and op2 then
			 if Duel.SelectYesNo(tp,aux.Stringid(10101008,2)) then
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			 else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			 end
		  elseif op1 then
				Duel.SendtoGrave(tc,REASON_EFFECT)
		  else
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		  end
	   end
	end
end
function c10101008.tdfilter(c)
	return (c:IsAbleToRemove() or c:IsAbleToGrave()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6330)
end
function c10101008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c10101008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end