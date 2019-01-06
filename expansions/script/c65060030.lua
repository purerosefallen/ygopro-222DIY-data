--逆龙之门
function c65060030.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c65060030.econ)
	e1:SetTarget(c65060030.etg)
	e1:SetValue(c65060030.efilter)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c65060030.thcon)	
	e2:SetTarget(c65060030.thtg)
	e2:SetOperation(c65060030.thop)
	c:RegisterEffect(e2)
end
function c65060030.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c65060030.thfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9da4) and c:IsAbleToHand()
end
function c65060030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060030.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
	Duel.SetChainLimit(c65060030.chlimit)
end
function c65060030.chlimit(e,ep,tp)
	return tp==ep
end
function c65060030.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_HAND,nil,e,0,1-tp,false,false,POS_FACEUP_ATTACK)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft>g:GetCount() then ft=g:GetCount() end
		local sg=g:FilterSelect(1-tp,aux.TRUE,1,ft,nil)
		local num=Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		if num>0 and Duel.IsExistingMatchingCard(c65060030.thfil,tp,LOCATION_DECK,0,1,nil) then
			if num>Duel.GetMatchingGroupCount(c65060030.thfil,tp,LOCATION_DECK,0,nil) then num=Duel.GetMatchingGroupCount(c65060030.thfil,tp,LOCATION_DECK,0,nil) end
			local thg=Duel.SelectMatchingCard(tp,c65060030.thfil,tp,LOCATION_DECK,0,1,num,nil)
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
	if g:GetCount()<=0 then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,hg)
		Duel.ShuffleHand(1-tp)
	end
end
function c65060030.efil(c)
	return c:IsFaceup() and c:IsSetCard(0x9da4) and c:IsType(TYPE_EFFECT)
end
function c65060030.econ(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65060030.efil,tp,LOCATION_MZONE,0,1,nil)
end
function c65060030.etg(e,c)
	return (c:IsFaceup() and c:IsSetCard(0x9da4) and c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)) or c==e:GetHandler()
end
function c65060030.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end