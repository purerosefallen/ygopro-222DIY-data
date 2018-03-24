--LA Da'ath 榮耀的拉斐兒
function c12010005.initial_effect(c)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12010005,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,12010005)
	e4:SetTarget(c12010005.tgtg)
	e4:SetOperation(c12010005.tgop)
	c:RegisterEffect(e4)
	--disable and SpecialSummon
	local e2=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12010005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetOperation(c12010005.disop)
	c:RegisterEffect(e2)
end
function c12010005.filter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c12010005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12010005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12010005.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12010005.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c12010005.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c12010005.cmfilter(c,e,tp)
	return c:IsCode(12010005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12010005.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g:IsContains(ec) and (re:GetHandler():IsSetCard(0xfba) or re:GetHandler():IsSetCard(0xfbc)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(12010005,2)) then
			if Duel.NegateEffect(ev) then
				 local sg=Duel.GetMatchingGroup(c12010005.cmfilter,tp,LOCATION_MZONE,0,nil,e,tp)
				 if sg:GetCount()>0 then
				 local tc=sg:GetFirst()
				 while tc do
				   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
				   if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
					  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					  end
					  tc=g:GetNext()
					 end
			end
		end
	end
end