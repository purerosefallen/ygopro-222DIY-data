--艺形魔-纸死神
function c21520189.initial_effect(c)
	--spsumon 1 shapevil 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetDescription(aux.Stringid(21520189,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520189)
	e1:SetCondition(c21520189.sdrcon)
	e1:SetCost(c21520189.sdrcost)
	e1:SetTarget(c21520189.sdrtg)
	e1:SetOperation(c21520189.sdrop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520189,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520189)
	e2:SetTarget(c21520189.tgtg)
	e2:SetOperation(c21520189.tgop)
	c:RegisterEffect(e2)
	local e2_2=e2:Clone()
	e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_2)
	--SPECIAL_SUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520189,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520189.spcon)
	e3:SetTarget(c21520189.sptg)
	e3:SetOperation(c21520189.spop)
	c:RegisterEffect(e3)
end
function c21520189.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520189.spfilter(c,e,tp)
	return c:IsSetCard(0x490) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c21520189.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()&(TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
end
function c21520189.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520189.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c21520189.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520189.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21520189.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=(Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLP(1-tp)>atk)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local op=2
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(21520189,3),aux.Stringid(21520189,4))
		elseif not b1 and b2 then
			op=1
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,4))
		elseif b1 and not b2 then
			op=0
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,3))
		end
		if op==0 then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif op==1 then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.Damage(tc:GetControler(),atk,REASON_EFFECT)
	end
end
function c21520189.fieldfilter(c)
	return c:IsCode(21520181) and c:IsFaceup()
end
function c21520189.sdrcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c21520189.fieldfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
		return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
	else
		return Duel.GetTurnPlayer()==tp
	end
end
function c21520189.sdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST) 
end
function c21520189.sdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520189.pfilter,tp,LOCATION_HAND,0,3,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(c21520189.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
--	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c21520189.sdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(c21520189.pfilter,tp,LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(c21520189.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if g:GetCount()>0 and hg:GetCount()>2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local pg=hg:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,pg)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local p=tp
		local tc=sg:GetFirst()
		local op=2
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(21520189,3),aux.Stringid(21520189,4))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
			op=0
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,3))
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			op=1
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520189,4))
		end
		if op==1 then 
			p=1-tp
		end
		if Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP)>0 then
			--can not activate
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c21520189.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e1)
			--destroy
			local e2=Effect.CreateEffect(c)
			e2:SetCategory(CATEGORY_DESTROY)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_BATTLE_DAMAGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(c21520189.destg)
			e2:SetOperation(c21520189.desop)
			tc:RegisterEffect(e2)
		end
	end
end
function c21520189.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c21520189.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end
end
function c21520189.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDistruable,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c21520189.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
end
function c21520189.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,6)
	Duel.ConfirmDecktop(tp,6)
	local tc=g:GetFirst()
	local tgg=Group.CreateGroup()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x490) then
			tgg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	local ct=Duel.SendtoGrave(tgg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local otg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SendtoGrave(otg,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
