--唤灵术 慈悲
function c65050007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050007,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65051007)
	e1:SetTarget(c65050007.target)
	e1:SetOperation(c65050007.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050007,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65051007)
	e2:SetTarget(c65050007.target2)
	e2:SetOperation(c65050007.activate2)
	c:RegisterEffect(e2)
	--TOHAND
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,65051012)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c65050007.thtg)
	e3:SetOperation(c65050007.thop)
	c:RegisterEffect(e3)
end

function c65050007.filter2(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c) and c:IsSetCard(0x3da1)
end
function c65050007.matfilter2(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function c65050007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c65050007.matfilter2,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c65050007.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050007.activate2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c65050007.matfilter2,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c65050007.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		tc:SetMaterial(mat)
		Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


function c65050007.filter(c,e,tp,m1,m2,ft)
	if not c:IsSetCard(0x3da1) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if mg:IsContains(c) then mg:RemoveCard(c) end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return mg:IsExists(c65050007.mfilterf,1,nil,tp,mg,c)
	end
end
function c65050007.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),1,99,rc)
	else return false end
end
function c65050007.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x3da1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65050007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c65050007.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c65050007.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c65050007.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c65050007.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65050007.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if mg:IsContains(tc) then mg:RemoveCard(tc) end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c65050007.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


function c65050007.thfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
		and Duel.IsExistingMatchingCard(c65050007.ththfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetLevel())
end

function c65050007.ththfil(c,lv)
	return c:IsType(TYPE_RITUAL) and c:GetLevel()==lv and c:IsAbleToHand()
end
function c65050007.thfil(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end

function c65050007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65050007.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050007.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c65050007.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65050007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c65050007.ththfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetLevel())
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(c65050007.ritthfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050007,2)) then
				Duel.BreakEffect()
				local lg=Duel.SelectMatchingCard(tp,c65050007.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
				if lg:GetCount()>0 then
					Duel.SendtoHand(lg,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,lg)
				end
			end
		end
	end
end
function c65050007.ritthfil(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end