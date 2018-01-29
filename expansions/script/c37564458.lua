--百慕 急速走红·爱尔普莉娜
local m=37564458
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,Senya.check_fusion_set_prism,Senya.check_fusion_set_prism,function(c) return Senya.check_fusion_set_prism(c) and c:IsFusionType(TYPE_XYZ) end)
	Senya.AddSelfFusionProcedure(c,LOCATION_MZONE,Duel.SendtoDeck,true)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep~=tp
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local check=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and not e:GetHandler():IsType(TYPE_TOKEN)
		if not check then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			return
		end
		local op=Duel.SelectOption(tp,m*16,m*16+1)
		if op==1 then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
			Senya.OverlayCard(g:GetFirst(),e:GetHandler())
		end
	end)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return Senya.CheckPrism(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsType(TYPE_XYZ)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttackAbove(1) end,tp,LOCATION_MZONE,LOCATION_MZONE,0,c)
		local atk=g:GetSum(Card.GetAttack)
		if #g>0 and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
	end
end