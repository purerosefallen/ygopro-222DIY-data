local m=77707069
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local function uni_effect(mark,code)
		local function costf(c,e,tp)
			return c:IsCode(code) and c:IsAbleToRemoveAsCost()
				and (mark>0 or Duel.IsExistingMatchingCard(revf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil))
		end
		local function revf(c,e,tp)
			return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		end
		return {
			function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return Duel.IsExistingMatchingCard(costf,tp,LOCATION_GRAVE,0,1,nil,e,tp)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,costf,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				Duel.Remove(g,POS_FACEUP,REASON_COST)
				if mark>0 then
					e:SetCategory(0)
				else
					e:SetCategory(CATEGORY_SPECIAL_SUMMON)
					Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
				end
			end,
			function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if not c:IsRelateToEffect(e) then return false end
				if mark>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LINK_SPELL_KOISHI)
					e1:SetValue(0)
					e1:SetReset(0x1fe1000)
					c:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
					e1:SetValue(mark)
					e1:SetReset(0x1fe1000)
					c:RegisterEffect(e1)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(tp,revf,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
					if #g>0 then
						Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
					end
				end
			end
		}
	end
	local effect_list={
		[LINK_MARKER_TOP]=77707048,
		[LINK_MARKER_TOP_LEFT]=77707047,
		[LINK_MARKER_TOP_RIGHT]=77707052,
		[0]=77707068,
	}
	local target_list={}
	local operation_list={}
	for mark,code in pairs(effect_list) do
		local func=uni_effect(mark,code)
		table.insert(target_list,func[1])
		table.insert(operation_list,func[2])
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(Senya.multi_choice_target(m,table.unpack(target_list)))
	e1:SetOperation(Senya.multi_choice_operation(table.unpack(operation_list)))
	c:RegisterEffect(e1)
end
