--外身形 秽羽
function c65020011.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,65020011)
	e2:SetTarget(c65020011.tg)
	e2:SetOperation(c65020011.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetProperty(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c65020011.ccon)
	c:RegisterEffect(e3)
end
function c65020011.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and re:GetHandlerPlayer()~=tp
end

function c65020011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
	end
end

function c65020011.thfil(c,e,tp)
	return c:IsSetCard(0x3da5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65020011.opfil(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,c)>0 and not c:IsType(TYPE_TUNER)
end
function c65020011.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(c65020011.opfil,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(65020011,0)) then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,e:GetHandler())
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),e:GetHandler())
			end
		end
	end
end

