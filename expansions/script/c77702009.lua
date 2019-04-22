local m=77702009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local function select_gc(gc)
		return function(c)
			Duel.SetSelectedCard(gc)
			return true
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local gc=e:GetHandler():GetEquipTarget()
			local mg=Duel.GetRitualMaterial(tp)
			if not gc or not mg:IsContains(gc) then return false end
			return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,select_gc(gc),e,tp,mg,nil,Card.GetLevel,"Equal")
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local gc=e:GetHandler():GetEquipTarget()
		local mg=Duel.GetRitualMaterial(tp)
		if not gc or not mg:IsContains(gc) then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,LOCATION_HAND,0,1,1,nil,select_gc(gc),e,tp,mg,nil,Card.GetLevel,"Equal")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local lv=tc:GetLevel()
			Duel.SetSelectedCard(gc)
			Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,greater_or_equal)
			local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,"Equal")
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(function(c)
		return c:IsFaceup()
	end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK+LOCATION_EXTRA)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	cm.announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(cm.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		if g:IsExists(Card.IsCode,1,nil,ac) then
			Duel.Hint(HINT_CARD,0,m)
			c:CopyEffect(ac,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
	end
end
