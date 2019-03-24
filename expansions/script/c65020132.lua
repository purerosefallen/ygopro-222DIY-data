--响色的对位华台
function c65020132.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cancelll
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c65020132.con)
	e1:SetTarget(c65020132.tg)
	e1:SetOperation(c65020132.op)
	c:RegisterEffect(e1)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(c65020132.effectfilter)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	c:RegisterEffect(e5)
end
function c65020132.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65020132.cfil(c,tp)
	return c.material and c:IsSetCard(0xcda4) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c65020132.matfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c)
end
function c65020132.matfil(c,fc)
	if c:IsForbidden() or not c:IsAbleToHand() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c65020132.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65020132.cfil(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65020132.cfil,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c65020132.cfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65020132.fil(c,gsp)
	return gsp:IsContains(c)
end
function c65020132.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
			local g0=Duel.GetMatchingGroup(c65020132.matfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tc)
			local g1=Group.CreateGroup()
			while g0:GetCount()>0 do
				local g2=g0:Select(tp,1,1,nil)
				g1:Merge(g2)
				local code=g1:GetFirst():GetCode()
				g0:Remove(Card.IsCode,nil,code)
			end
			if Duel.SendtoHand(g1,tp,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,g1)
				Duel.BreakEffect()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g1:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)>0 and Duel.SelectYesNo(tp,aux.Stringid(65020132,0)) then
					local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
					if num>g1:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false) then num=g1:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false) end
					local gsp=g1:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
					Duel.SpecialSummon(gsp,0,tp,tp,false,false,POS_FACEUP)
					g1:Remove(c65020132.fil,nil,gsp)
				end
				if g1:FilterCount(Card.IsAbleToGrave,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(65020132,1)) then
					local gtg=g1:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
					Duel.SendtoGrave(gtg,REASON_EFFECT)
				end
			end
		end
	end
end

function c65020132.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xcda4) and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end