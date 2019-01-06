--辉忆的幸所在
function c65020066.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--1t1c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65020066,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65020066.cost)
	e1:SetTarget(c65020066.tg1)
	e1:SetOperation(c65020066.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(65020066,1))
	e2:SetTarget(c65020066.tg2)
	e2:SetOperation(c65020066.op2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(65020066,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE)
	e3:SetTarget(c65020066.tg3)
	e3:SetOperation(c65020066.op3)
	c:RegisterEffect(e3)
end
function c65020066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65020066.refil1(c,tp)
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>1 and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(8)
end
function c65020066.fil1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c65020066.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020066.refil1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c65020066.fil1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c65020066.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c65020066.refil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g1:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65020066.fil1,tp,LOCATION_GRAVE,0,2,nil,e,tp) and Duel.GetMZoneCount(tp)>1 then
		local g=Duel.SelectMatchingCard(tp,c65020066.fil1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c65020066.fil2(c,e,tp)
	local num=c:GetLink()
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65020066.refil2,tp,LOCATION_MZONE,0,num,nil)
end
function c65020066.refil2(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelBelow(4) and c:IsReleasableByEffect() 
end
function c65020066.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020066.fil2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65020066.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c65020066.fil2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local num=g1:GetFirst():GetLink()
		local g=Duel.SelectMatchingCard(tp,c65020066.refil2,tp,LOCATION_MZONE,0,num,num,nil)
		if Duel.Release(g,REASON_EFFECT)==num then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


function c65020066.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c65020066.filter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c65020066.filter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and c65020066.isfit(c,mc)
end
function c65020066.isfit(c,mc)
	return (mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))) or aux.IsCodeListed(mc,c:GetCode())
end
function c65020066.refil3(c)
	return c:IsType(TYPE_LINK) and c:IsReleasableByEffect()
end
function c65020066.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020066.refil3,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65020066.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c65020066.op3(e,tp,eg,ep,ev,re,r,rp)
	local gn=Duel.SelectMatchingCard(tp,c65020066.refil3,tp,LOCATION_MZONE,0,1,1,nil)
	if gn:GetCount()>0 and Duel.Release(gn,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65020066.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65020066.filter2),tp,LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	end
end