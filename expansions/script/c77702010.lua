local m=77702010
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_front_side=m+1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Senya.DiscardHandCost(1))
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(m*16)
	e1:SetCountLimit(1)
	e1:SetCost(Senya.DescriptionCost())
	local function dfilter(c)
		return c:IsAbleToGrave() and c:GetLevel()>1
	end
	local function rfilter(c)
		return c:IsLevelAbove(7)
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local mg=Duel.GetMatchingGroup(dfilter,tp,LOCATION_DECK,0,nil)
			return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,rfilter,e,tp,mg,nil,Card.GetLevel,"Equal")
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local mg=Duel.GetMatchingGroup(dfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,LOCATION_HAND,0,1,1,nil,rfilter,e,tp,mg,nil,Card.GetLevel,"Equal")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local lv=tc:GetLevel()
			Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,"Equal")
			local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,"Equal")
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetDescription(m*16+1)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local atks={}
		for p=0,1 do
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			atks[p]=g:GetSum(Card.GetAttack)
		end
		return atks[1-tp]>atks[tp]
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Senya.IsDFCTransformable(e:GetHandler()) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not cm.target(e,tp,eg,ep,ev,re,r,rp,0) or c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
		Senya.TransformDFCCard(c)
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+37564777)
	e1:SetProperty(0x14000)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsReason(REASON_DESTROY)
	end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
