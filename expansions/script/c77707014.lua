local m=77707014
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_back_side=m-7
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND)<=2
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if chk==0 then return Duel.GetMZoneCount(tp)>1 and mg1:CheckSubGroup(cm.check,2,2) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,2,e:GetHandler(),TYPE_MONSTER) end
		local g=Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,e:GetHandler(),TYPE_MONSTER)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg1,2,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetMZoneCount(tp)<=1 or not e:GetHandler():IsRelateToEffect(e) then return end
		local mg1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=mg1:SelectSubGroup(tp,cm.check,false,2,2)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>1 then
			local dg=Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,e:GetHandler(),TYPE_MONSTER)
			if #dg>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg_=dg:Select(tp,2,2,nil)
				Duel.BreakEffect()
				Duel.Destroy(dg_,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.check(g)
	return g:GetClassCount(Card.GetOrignalCode)==1
end