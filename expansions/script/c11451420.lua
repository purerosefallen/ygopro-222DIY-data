--shrimp captain of dragon palace
function c11451420.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11451405)
	e1:SetCondition(c11451420.condition)
	e1:SetCost(c11451420.cost)
	e1:SetTarget(c11451420.target2)
	e1:SetOperation(c11451420.operation2)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,11451420)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c11451420.condition2)
	e2:SetTarget(c11451420.target)
	e2:SetOperation(c11451420.operation)
	c:RegisterEffect(e2)
end
function c11451420.filter(c)
	return bit.band(c:GetType(),0x82)==0x82 and not c:IsPublic()
end
function c11451420.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c11451420.filter3(c,tp)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c11451420.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c11451420.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) and not e:GetHandler():IsPublic() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c11451420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11451420.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local c=g:GetFirst()
	Duel.ConfirmCards(1-tp,c)
end
function c11451420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c11451420.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 and g:IsExists(c11451420.filter2,1,nil) and Duel.SelectYesNo(p,aux.Stringid(11451420,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g2=g:FilterSelect(p,c11451420.filter2,1,1,nil)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g2)
	end
	Duel.ShuffleDeck(p)
end
function c11451420.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c11451420.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_MZONE)
end
function c11451420.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			local g=Duel.GetMatchingGroup(c11451420.filter3,tp,LOCATION_MZONE,0,nil,tp)
			if g:GetCount()~=0 then
				if Duel.SelectYesNo(tp,aux.Stringid(11451420,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g2=g:FilterSelect(tp,c11451420.filter3,1,1,nil,tp)
					if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
						local e3=Effect.CreateEffect(e:GetHandler())
						e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e3:SetCode(EVENT_PHASE+PHASE_END)
						e3:SetReset(RESET_PHASE+PHASE_END)
						e3:SetLabelObject(g2:GetFirst())
						e3:SetCountLimit(1)
						e3:SetOperation(c11451420.operation3)
						Duel.RegisterEffect(e3,tp)
					end
				end
			end
		end
	end
end
function c11451420.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end