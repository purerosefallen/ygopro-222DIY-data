--teemo
local m=37564317
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Activate
	Auxiliary.AddRitualProcEqual2(c)
	Senya.enable_get_all_cards()
	--[[if not cm.gg then
		cm.gg=Group.CreateGroup()
		cm.gg:KeepAlive()
		cm.fit_monster={}
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(function()
			local g=Senya.get_all_cards:Clone()
			local rg=Group.CreateGroup()
			g:ForEach(function(c)
				if (c:GetOriginalType() & 0x81)==0x81 and not cm.gg:IsExists(cm.ctfilter,1,nil,c:GetOriginalCode()) then
					rg:AddCard(c)
					cm.gg:AddCard(c)
				end
			end)
			rg:ForEach(function(c)
				table.insert(cm.fit_monster,c:GetOriginalCode())
			end)
		end)
		Duel.RegisterEffect(e1,0)
	end]]
end
function cm.ctfilter(c,code)
	return c:GetOriginalCode()==code
end
